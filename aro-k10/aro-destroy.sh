echo '-------Deleting an ARO Cluster only (typically about 35 mins)'
starttime=$(date +%s)
. ./setenv.sh

az aro delete --resource-group $MY_PREFIX-$MY_GROUP --name $MY_CLUSTER -y

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to destroy an ARO Cluster is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
