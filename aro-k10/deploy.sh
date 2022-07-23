echo '-------Creating an ARO Cluster + K10 (~35 mins)'
starttime=$(date +%s)

#Create an ARO cluster
./aro-deploy.sh

#Deploy K10 + PostgreSQL + backup policy 
./k10-deploy.sh

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for ARO+K10 deployment is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
