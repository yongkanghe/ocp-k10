starttime=$(date +%s)
. ./setenv.sh

echo '-------Deleting Postgresql and Kasten K10'

helm uninstall postgres -n yong-postgresql
helm uninstall k10 -n kasten-io
kubectl delete ns yong-postgresql
kubectl delete ns kasten-io

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
