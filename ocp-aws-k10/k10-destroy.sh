starttime=$(date +%s)
. ./setenv.sh
# TEMP_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
# FIRST2=$(echo -n $TEMP_PREFIX | head -c2)
# LAST2=$(echo -n $TEMP_PREFIX | tail -c2)
# OCP_GCP_MY_PREFIX=$(echo $FIRST2$LAST2)

echo '-------Deleting Postgresql and Kasten K10'

helm uninstall postgres -n yong-postgresql
helm uninstall k10 -n kasten-io
kubectl delete ns yong-postgresql
kubectl delete ns kasten-io

echo '-------Deleting objects from S3 Storage Bucket'
aws s3 rb s3://$(cat k10_ocp_aws_bucketname) --force

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
