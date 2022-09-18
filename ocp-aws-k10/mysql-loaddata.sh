#Create a DB, Table and insert data
oc exec -ti mysql-0 -n yong-mysql -c mysql -- mysql --user=root --password=password4yong1<<EOF
CREATE DATABASE db4yong1;
USE db4yong1;
CREATE TABLE employee (emp_name VARCHAR(20), emp_id int(5), location VARCHAR(20));
INSERT INTO employee VALUES ('Yongkang He','1','Singapore');
SELECT * FROM employee;
EOF
