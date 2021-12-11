echo '-------Deploying Postgresql on ECP and Protecting it via K10'
starttime=$(date +%s)
. ./setenv.sh
export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1 | sed -e 's/\"//g') 
export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1 | sed -e 's/\"//g')
ecp_bucket_NAME=$MY_BUCKET-$(date +%s)
echo $ecp_bucket_NAME > ecp_bucketname

echo '-------Create and Annotate the volumesnapshotclass'
#Get the name of the secret that contains credentials for HPE Datafabric cluster
SECRETNAME=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].parameters.csi\.storage\.k8s\.io\/provisioner-secret-name}')

#Get the namespace in which the secret HPE Datafabric cluster is deployed
SECRETNAMESPACE=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].parameters.csi\.storage\.k8s\.io\/provisioner-secret-namespace}')

#Get the HPE datafabric cluster’s rest server ip addresses
RESTSERVER=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].parameters.restServers}')

#Get the HPE datafabric cluster’s name
CLUSTER=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].parameters.cluster}')

cat <<EOF | kubectl apply -f -
apiVersion: snapshot.storage.k8s.io/v1beta1
kind: VolumeSnapshotClass
metadata:
  annotations:
    k10.kasten.io/is-snapshot-class: "true"
  name: mapr-snapshotclass
  namespace: $SECRETNAMESPACE
driver: com.mapr.csi-kdf
deletionPolicy: Delete
parameters:
  restServers: $RESTSERVER
  cluster: $CLUSTER
  csi.storage.k8s.io/snapshotter-secret-name: $SECRETNAME
  csi.storage.k8s.io/snapshotter-secret-namespace: $SECRETNAMESPACE
EOF

echo '-------Install K10'
kubectl create ns kasten-io
helm repo add kasten https://charts.kasten.io/
helm install k10 kasten/k10 --namespace=kasten-io \
    --set global.persistence.metering.size=1Gi \
    --set prometheus.server.persistentVolume.size=1Gi \
    --set global.persistence.catalog.size=1Gi \
    --set global.persistence.jobs.size=1Gi \
    --set global.persistence.logging.size=1Gi \
    --set global.persistence.grafana.size=1Gi \
    --set externalGateway.create=true \
    --set auth.tokenAuth.enabled=true \
    --set grafana.enabled=true \
    --set grafana.persistence.storageClassName=hcp-mapr-cluster \
    --set global.persistence.storageClass=hcp-mapr-cluster 

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Deploying a Postgresql database'
kubectl create namespace k10-postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --namespace k10-postgresql postgres bitnami/postgresql \
  --set persistence.size=1Gi \
  --set persistence.storageClass=hcp-mapr-cluster \
  --set volumePermissions.enabled=true

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > ecp-token
echo My Cluster ID is $clusterid >> ecp-token
echo "" | awk '{print $1}' > ecp-token

echo '-------Creating a S3 profile secret'
kubectl create secret generic k10-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

echo '-------Wait for 1 or 2 mins for the Web UI IP and token'
kubectl wait --for=condition=ready --timeout=180s -n kasten-io pod -l component=jobs
kubectl expose service gateway -n kasten-io --type=NodePort --name=gateway-nodeport
kubectl label service gateway-nodeport hpecp.hpe.com/hpecp-internal-gateway=true -n kasten-io

sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
echo "Here is the token to login K10 Web UI" >> ecp-token
echo "" | awk '{print $1}' >> ecp-token
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode | awk '{print $1}' >> ecp-token

echo "" | awk '{print $1}' >> ecp-token

nodeport=$(kubectl describe svc gateway-nodeport -n kasten-io | grep Annotations | awk '{print $3}')
k10ui=http://$nodeport/k10/#

echo -e "\nCopy the token before clicking the link to log into K10 Web UI -->> $k10ui" >> ecp-token
echo "" | awk '{print $1}' >> ecp-token

echo '-------Waiting for K10 services are up running in about 1 or 2 mins'
kubectl wait --for=condition=ready --timeout=600s -n kasten-io pod -l component=catalog

echo '-------Creating a S3 profile'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Profile
metadata:
  name: $MY_OBJECT_STORAGE_PROFILE
  namespace: kasten-io
spec:
  type: Location
  locationSpec:
    credential:
      secretType: AwsAccessKey
      secret:
        apiVersion: v1
        kind: Secret
        name: k10-s3-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $(cat ecp_bucketname)
      objectStoreType: S3
      region: $MY_REGION
EOF

echo '------Create backup policies'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Policy
metadata:
  name: k10-postgresql-backup
  namespace: kasten-io
spec:
  comment: ""
  frequency: "@hourly"
  actions:
    - action: backup
      backupParameters:
        profile:
          namespace: kasten-io
          name: $MY_OBJECT_STORAGE_PROFILE
    - action: export
      exportParameters:
        frequency: "@hourly"
        migrationToken:
          name: ""
          namespace: ""
        profile:
          name: $MY_OBJECT_STORAGE_PROFILE
          namespace: kasten-io
        receiveString: ""
        exportData:
          enabled: true
      retention:
        hourly: 0
        daily: 0
        weekly: 0
        monthly: 0
        yearly: 0
  retention:
    hourly: 4
    daily: 1
    weekly: 1
    monthly: 0
    yearly: 0
  selector:
    matchExpressions:
      - key: k10.kasten.io/appNamespace
        operator: In
        values:
          - k10-postgresql
EOF

sleep 7

echo '-------Kickoff the on-demand backup job'
sleep 8

cat <<EOF | kubectl create -f -
apiVersion: actions.kio.kasten.io/v1alpha1
kind: RunAction
metadata:
  generateName: run-backup-
spec:
  subject:
    kind: Policy
    name: k10-postgresql-backup
    namespace: kasten-io
EOF

echo '-------Accessing K10 UI'
cat ecp-token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is ONLY $(($duration / 60)) minutes $(($duration % 60)) seconds for Kasten K10+Postgresql+Policy+OnDemandBackup."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
