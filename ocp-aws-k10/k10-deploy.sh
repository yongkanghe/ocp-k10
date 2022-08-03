echo '-------Deploying Kasten K10 and Postgresql'
starttime=$(date +%s)
. ./setenv.sh
# MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1 | sed -e 's/\"//g') 
export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1 | sed -e 's/\"//g')

echo '-------Set the default sc & vsc'
oc annotate volumesnapshotclass csi-aws-vsc k10.kasten.io/is-snapshot-class=true
oc annotate sc gp2 storageclass.kubernetes.io/is-default-class-
oc annotate sc gp2-csi storageclass.kubernetes.io/is-default-class=true

echo '-------Install K10'
kubectl create ns kasten-io
helm repo add kasten https://charts.kasten.io
helm repo update

#For Production, remove the lines ending with =1Gi from helm install
#For Production, remove the lines ending with airgap from helm install
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
    --set global.persistence.storageClass=gp2-csi
# --set grafana.persistence.storageClassName=gp2-csi \

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Deploying a PostgreSQL database'
kubectl create namespace yong-postgresql
oc adm policy add-scc-to-user anyuid -z default -n yong-postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --namespace yong-postgresql postgres bitnami/postgresql \
  --set primary.persistence.size=1Gi
# --set global.storageClass=managed-csi

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > ocp_aws_token
echo My Cluster ID is $clusterid >> ocp_aws_token

echo '-------Wait for 1 or 2 mins for the Web UI IP and token'
kubectl wait --for=condition=ready --timeout=180s -n kasten-io pod -l component=jobs
k10ui=http://$(kubectl get route -n kasten-io | grep k10-route | awk '{print $2}')/k10/#
echo -e "\nCopy/Paste the link to browser to access K10 Web UI" >> ocp_aws_token
echo -e "\n$k10ui" >> ocp_aws_token
echo "" | awk '{print $1}' >> ocp_aws_token
sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
echo "Copy/Paste the token below to Signin K10 Web UI" >> ocp_aws_token
echo "" | awk '{print $1}' >> ocp_aws_token
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode | awk '{print $1}' >> ocp_aws_token
# kubectl get secret $sa_secret -n kasten-io -o json | jq '.metadata.annotations."openshift.io/token-secret.value"' | sed -e 's/\"//g' >> ocp_aws_token
echo "" | awk '{print $1}' >> ocp_aws_token

echo '-------Waiting for K10 services are up running in about 1 or 2 mins'
kubectl wait --for=condition=ready --timeout=300s -n kasten-io pod -l component=catalog

#Create a Azure Blob Storage location profile
./ocp-s3-location.sh

#Create a Postgresql backup policy
./postgresql-policy.sh

echo '-------Accessing K10 UI'
cat ocp_aws_token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for K10 deployment is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'