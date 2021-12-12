starttime=$(date +%s)
. ./setenv.sh

echo "-------Delete mongodb & kasten-io"
helm uninstall mongodb -n k10-mongodb
helm uninstall k10 -n kasten-io
kubectl delete ns k10-mongodb
kubectl delete ns kasten-io

echo '-------Deleting objects from the bucket'
aws s3 rb s3://$(cat rosa_bucketname) --force

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
