#Verify if the data has been recoved in the target cluster
oc exec -ti mysql-0 -n yong-mysql -c mysql -- mysql --user=root --password=password4yong1<<EOF
USE db4yong1;
SELECT * FROM employee;
EOF
