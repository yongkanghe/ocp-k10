#### Follow [@YongkangHe](https://twitter.com/yongkanghe) on Twitter, Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

I just want to learn the various Data Management capabilities e.g. Container's Backup/Restore, Disaster Recovery and Application Mobility. It is challenging to create an OpenShift cluster if you are not familiar to it. After the OCP Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.This script based automation allows you to build a ready-to-use Kasten K10 demo environment on a running Red Hat OpenShift Cluster on AWS Cloud in 3 minutes (Self-Managed OpenShift Cluster on AWS).

![image](https://pbs.twimg.com/media/FGZd5pBVgAE4Rp3?format=png&name=small)

If you don't have an OpenShift Cluster, you can watch the Youtube video and follow the guide to build a ROSA cluster on AWS Cloud. Once the ROSA Cluster is up running, you can proceed to the next steps.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/amLN6-JxygU/0.jpg)](https://www.youtube.com/watch?v=amLN6-JxygU)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Here're the prerequisities. 
1. Log in to the terminal where you can access the OpenShift Cluster via oc
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/yongkanghe/ocp-k10.git
````
3. Complete the preparation tasks first
````
cd ocp-k10/ocp-aws-k10;./ocp-aws-prep.sh
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
2. Deploy a Postgresql database
3. Create a AWS S3 location profile
4. Create a backup policy
5. Run an on-demand backup job

# To delete the labs, run 
````
./k10-destroy.sh
````
1. Remove Postgresql Database
2. Remove Kasten K10
3. Remove all the relevant disks
4. Remove all the relevant snapshots
5. Remove the objects from the bucket

# 3 minutes to protect containers on ROSA Cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/WDC20GQWjtE/0.jpg)](https://www.youtube.com/watch?v=WDC20GQWjtE)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to migrate containers on OCP Cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/mjG-GOnJ-Lo/0.jpg)](https://www.youtube.com/watch?v=mjG-GOnJ-Lo)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# OpenShift Backup and Restore
https://blog.kasten.io/kubernetes-backup-with-openshift-container-storage

# Kubernetes / Kasten Learning
http://k8s.yongkang.cloud

# Earn Kubernetes Badges
https://lnkd.in/gpptXmnY

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Contributors

#### Follow [Yongkang He](http://yongkang.cloud) on LinkedIn, Join [Kubernetes Data Management](https://www.linkedin.com/groups/13983251) LinkedIn Group
