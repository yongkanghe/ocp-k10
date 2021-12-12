I just want to build a Red Hat OpenShift Service on AWS (aka ROSA) to learn the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. It is challenging to create a ROSA cluster if you are not familiar to it. After the ROSA Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://assets.openshift.com/hubfs/OpenShift%20and%20Kasten%20logos.png)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment on a running Red Hat OpenShift Service on AWS Cloud in 3 minutes. If you don't have a ROSA Cluster, you can watch the Youtube video and follow the guide to build a ROSA cluster on AWS Cloud. Once the ROSA Cluster is up running, you can proceed to the next steps. 

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/amLN6-JxygU/0.jpg)](https://www.youtube.com/watch?v=amLN6-JxygU)

# Here're the prerequisities. 
1. Log in to the terminal where you can access the ROSA Cluster via Kubectl
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/yongkanghe/ocp-k10.git
````
3. Complete the preparation tasks first
````
cd ocp-k10/rosa-k10;./rosaprep.sh
````
4. Optionally, you can customize region, bucketname, object storage profile etc.
````
vim setenv.sh
````
 
# To build the labs, run 
````
./k10-deploy.sh
````
1. Install Kasten K10
2. Deploy a MongoDB database
3. Create a AWS S3 location profile
4. Create a backup policy
5. Run an on-demand backup job

# To delete the labs, run 
````
./k10-destroy.sh
````
1. Remove MongoDB Database
2. Remove Kasten K10
3. Remove all the relevant disks
4. Remove all the relevant snapshots
5. Remove the objects from the bucket

# 3 minutes to protect containers on ROSA Cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/pYgJHSfogEE/0.jpg)](https://www.youtube.com/watch?v=pYgJHSfogEE)

# OpenShift Backup and Restore
https://blog.kasten.io/kubernetes-backup-with-openshift-container-storage

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Free Kubernetes Learning
https://learning.kasten.io 

# Kasten - DevOps tool of the month July 2021
http://k10.yongkang.cloud

# Contributors

### [Yongkang He](http://yongkang.cloud)




