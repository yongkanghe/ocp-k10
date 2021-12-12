starttime=$(date +%s)
. setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

echo "-------Delete mongodb & kasten-io"
./helm uninstall mongodb -n k10-mongodb
./helm uninstall k10 -n kasten-io
kubectl delete ns k10-mongodb
kubectl delete ns kasten-io

# echo '-------Deleting the bucket'
# ibmcloud cos objects --bucket $(cat my_ibm_bucket) --region $MY_REGION --output json| grep Key | awk '{print $2}' | sed 's/\"//g' | sed 's/\,//g' > k10objects
# for i in `cat k10objects`;do echo $i;ibmcloud cos object-delete --bucket $(cat my_ibm_bucket) --key $i --region $MY_REGION --force;done 
#ibmcloud cos bucket-delete --bucket $(cat my_ibm_bucket) --region $MY_REGION --force

# echo '-------Deleting kubeconfig for this cluster'
# kubectl config delete-context $(kubectl config get-contexts | grep $MY_PREFIX-$MY_CLUSTER | awk '{print $2}')

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
