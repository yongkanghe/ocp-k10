echo '-------Deploying MongoDB on ROSA and Protecting it via K10'
starttime=$(date +%s)

. ./setenv.sh

export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1 | sed -e 's/\"//g') 
export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1 | sed -e 's/\"//g')

echo $MY_BUCKET-$(date +%s) > rosa_bucketname

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
    --set scc.create=true \
    --set route.enabled=true \
    --set auth.tokenAuth.enabled=true \
    --set grafana.enabled=true \
    --set grafana.persistence.storageClassName=gp2-csi \
    --set global.persistence.storageClass=gp2-csi

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Annotate the volumesnapshotclass'
oc annotate volumesnapshotclass csi-aws-vsc k10.kasten.io/is-snapshot-class=true

echo '-------Deploying a MongoDB database'
kubectl create namespace k10-mongodb
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb -n k10-mongodb \
  --set persistence.storageClass=gp2-csi \
  --set persistence.size=1Gi \
  --set volumePermissions.securityContext.runAsUser="auto" \
  --set podSecurityContext.fsGroup="auto" \
  --set podSecurityContext.enabled=false \
  --set containerSecurityContext.enabled=false 

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > rosa-token
echo My Cluster ID is $clusterid >> rosa-token

echo '-------Creating a S3 profile secret'
kubectl create secret generic k10-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

echo '-------Wait for 1 or 2 mins for the Web UI IP and token'
kubectl wait --for=condition=ready --timeout=180s -n kasten-io pod -l component=jobs
k10ui=http://$(kubectl get route -n kasten-io | grep k10-route | awk '{print $2}')/k10/#

echo -e "\nCopy below token before clicking the link to log into K10 Web UI -->> $k10ui" >> rosa-token
echo "" | awk '{print $1}' >> rosa-token

sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
echo "Here is the token to login K10 Web UI" >> rosa-token
echo "" | awk '{print $1}' >> rosa-token
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode | awk '{print $1}' >> rosa-token
#kubectl get secret $sa_secret -n kasten-io -o json | jq '.metadata.annotations."openshift.io/token-secret.value"' | sed -e 's/\"//g' >> rosa-token

echo "" | awk '{print $1}' >> rosa-token

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
      name: $(cat rosa_bucketname)
      objectStoreType: S3
      region: $MY_REGION
EOF

echo '------Create backup policies'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Policy
metadata:
  name: k10-mongodb-backup
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
          - k10-mongodb
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
    name: k10-mongodb-backup
    namespace: kasten-io
EOF

echo '-------Accessing K10 UI'
cat rosa-token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is ONLY $(($duration / 60)) minutes $(($duration % 60)) seconds for Kasten K10+MongoDB+Policy+OnDemandBackup."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
