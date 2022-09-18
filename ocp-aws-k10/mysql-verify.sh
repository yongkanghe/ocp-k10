#Verify if the data has been recoved in the target cluster
oc exec -ti mysql-0 -n yong-mysql -c mysql -- bash
mysql --user=root --password=password4yong1
USE db4yong1;
SELECT * FROM employee;
