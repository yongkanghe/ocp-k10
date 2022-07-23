echo '-------Creating an ARO Cluster only (typically about 35 mins)'
starttime=$(date +%s)
. ./setenv.sh

az group create \
  --name $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --location $ARO_MY_LOCATION

az network vnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --name aro-vnet4yong1 \
  --address-prefixes 10.8.0.0/23

az network vnet subnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name aro-vnet4yong1 \
  --name master-subnet4yong1 \
  --address-prefixes 10.8.0.0/24 \
  --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name aro-vnet4yong1 \
  --name worker-subnet4yong1 \
  --address-prefixes 10.8.1.0/24 \
  --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet update \
  --name master-subnet4yong1 \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name aro-vnet4yong1 \
  --disable-private-link-service-network-policies true

az aro create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --name $ARO_MY_CLUSTER \
  --vnet aro-vnet4yong1 \
  --master-subnet master-subnet4yong1 \
  --worker-subnet worker-subnet4yong1 \
  --pull-secret @pull-secret.txt

PASSWORD=$(az aro list-credentials --name $ARO_MY_CLUSTER --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP -o tsv --query kubeadminPassword)

apiServer=$(az aro show -g $ARO_MY_PREFIX-$ARO_MY_GROUP -n $ARO_MY_CLUSTER --query apiserverProfile.url -o tsv)

oc login $apiServer -u kubeadmin -p $PASSWORD --insecure-skip-tls-verify

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to build an ARO Cluster is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
