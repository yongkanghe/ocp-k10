starttime=$(date +%s)
. ./setenv.sh

echo '-------Deleting an ARO Cluster (typically in less than 10 mins)'
az group delete -g $ARO_MY_PREFIX-$ARO_MY_GROUP --yes

ARO_CONTEXT=$(az aro list | grep aro4yong1 | awk '{print $6}' | sed -e 's/https\:\/\/console-openshift-console\.//' | sed -e 's/\///' | sed -e 's/apps\.//' | sed -e 's/\.westus\.aroapp\.io//')
kubectl config delete-context $(kubectl config get-contexts | grep $ARO_CONTEXT | awk '{print $2}')
echo "" | awk '{print $1}'

# echo '-------Deleting the app registration created by AKS'
# MYID=$(az ad sp list --show-mine --query [].servicePrincipalNames -o table | grep $MY_PREFIX-$MY_GROUP | awk '{print $2}')
# az ad app delete --id $MYID

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to clean up is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
