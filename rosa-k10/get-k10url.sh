nodeport=$(kubectl describe svc gateway-nodeport -n kasten-io | grep Annotations | awk '{print $3}')
k10ui=http://$nodeport/k10/#
echo $k10ui >> ecp-token
cat ecp-token
echo "" | awk '{print $1}'
./runonce.sh
