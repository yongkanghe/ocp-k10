starttime=$(date +%s)
. setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

#ibmcloud login --apikey @ibmapi.key    #Required if not using IBM Cloud Shell

ibmcloud target -r $MY_REGION
ibmcloud target -g $MY_PREFIX-$MY_RESOURCE_GROUP

oc config delete-context $(oc config get-contexts -o name | grep $MY_CLUSTER | head -1)

ibmcloud oc cluster rm --cluster $MY_PREFIX-$MY_CLUSTER --force-delete-storage -f #-q

echo '-------Deleting the bucket'
ibmcloud cos objects --bucket $(cat my_ibm_bucket) --region $MY_REGION --output json| grep Key | awk '{print $2}' | sed 's/\"//g' | sed 's/\,//g' > k10objects
for i in `cat k10objects`;do echo $i;ibmcloud cos object-delete --bucket $(cat my_ibm_bucket) --key $i --region $MY_REGION --force;done 
ibmcloud cos bucket-delete --bucket $(cat my_ibm_bucket) --region $MY_REGION --force

echo '-------Waiting for removing the cluster'
sleep 150

echo '-------Still waiting for removing the cluster'
sleep 150

echo '-------Almost complete to delete the cluster'
sleep 150

echo "-------Clean up the resources Subnet, Gateway, Service Key, Storage Instance and Resource Group"
ibmcloud is subnet-delete $MY_PREFIX-$MY_SUBNET -f
ibmcloud is public-gateway-delete $MY_PREFIX-$MY_GATEWAY -f
ibmcloud is vpc-delete $MY_PREFIX-$MY_VPC -f
ibmcloud resource service-key-delete $MY_PREFIX-$MY_SERVICE_KEY -g $MY_PREFIX-$MY_RESOURCE_GROUP -f
ibmcloud resource service-key-delete $(ibmcloud resource service-keys -q | grep -v Name | grep -v found | grep roks | awk '{print $1}') -g $MY_PREFIX-$MY_RESOURCE_GROUP -f
ibmcloud resource service-instance-delete $MY_PREFIX-$MY_OBJECT_STORAGE -g $MY_PREFIX-$MY_RESOURCE_GROUP -f
#ibmcloud resource group-delete $MY_PREFIX-$MY_RESOURCE_GROUP -f

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'