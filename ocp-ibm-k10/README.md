#### Follow [@YongkangHe](https://twitter.com/yongkanghe) on Twitter, Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

I just want to build a Red Hat OpenShift Container Platform to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. 

It is challenging to create an OpenShift cluster from IBM Cloud if you are not familiar to it. After the OCP Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://pbs.twimg.com/media/FGZh1BPVQAEE0Qq?format=jpg&name=small)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment running on OpenShift Container Platform on IBM Cloud in about 40 minutes. In order to demonstrate OpenShift Container Storage features, the OCP cluster will have 4 worker nodes and be built in a new vpc using a new subnet, gateway. This is bash shell based scripts which has been tested on IBM Cloud Shell in the Sydney region. 

# Here're the prerequisities. 
1. Log in to https://cloud.ibm.com, then open IBM Cloud Shell
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/yongkanghe/ocp-k10.git
````
3. Complete the preparation tasks first
````
cd ocp-k10/ocp-ibm-k10;./ibmprep.sh
````
4. Optionally, you can customize the clustername, worker flavor, zone, region, bucketname etc.
````
vim setenv.sh
````
 
# To build the labs, run 
````
./deploy.sh
````
1. Create an OCP Cluster from CLI
2. Install Kasten K10
3. Deploy a MongoDB database
4. Create an IBM COS location profile
5. Create a backup policy
6. Run an on-demand backup job

## NOTE: IBM Cloud Shell is emphemeral. 

The cloned respository including the temporary files will be removed after no activity for one hour. If that happened, you need to run below steps to re-created the files before you can destroy the labs. 

## To create the repository and the temporary files
````
git clone https://github.com/yongkanghe/ocp-ibm-k10.git;cd ocp-ibm-k10;./ibmprep.sh
````

# To delete the labs, run 
````
./destroy.sh
````
1. Remove OpenShift Cluster Cluster
2. Remove the VPC, Subnet, Gateway
3. Remove all the relevant disks
4. Remove all the relevant snapshots
5. Remove the objects from the bucket

# Learn how to automate OCP, OCS, MongoDB and K10.
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/HohBSwDjtmM/0.jpg)](https://www.youtube.com/watch?v=HohBSwDjtmM)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to build an OCP cluster via Web Console
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/FDvY9PSxgAQ/0.jpg)](https://www.youtube.com/watch?v=FDvY9PSxgAQ)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to backup/restore containers on OCP Cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/zMKIOCuEPyI/0.jpg)](https://www.youtube.com/watch?v=zMKIOCuEPyI)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to migrate containers on OCP Cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/mjG-GOnJ-Lo/0.jpg)](https://www.youtube.com/watch?v=mjG-GOnJ-Lo)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# For more details about OCP Backup and Restore
https://blog.kasten.io/kubernetes-backup-with-openshift-container-storage

https://blog.kasten.io/kasten-and-red-hat-migration-and-backup-for-openshift

# Kubernetes / Kasten Learning
http://k8s.yongkang.cloud

# Earn Kubernetes Badges
https://lnkd.in/gpptXmnY

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Contributors

#### Follow [Yongkang He](http://yongkang.cloud) on LinkedIn, Join [Kubernetes Data Management](https://www.linkedin.com/groups/13983251) LinkedIn Group
### [Adrian Gigante](https://www.linkedin.com/in/adrian-gigante/)
### [Michael Nguyen](https://www.linkedin.com/in/michael-nguyen-29811034/)
### [Hitesh Kataria](https://www.linkedin.com/in/hitesh-kataria09/)

