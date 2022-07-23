#-------Set the environment variables"
export ARO_MY_LOCATION=westus                  #Customize the location of your cluster
export ARO_MY_GROUP=aro-rg4yong1               #Customize your resource group name
export ARO_MY_CLUSTER=aro4yong1                #Customize your cluster name
export ARO_AZURE_STORAGE_ACCOUNT_ID=aroazsa4yong1  #Customize your Storage Account
export ARO_MY_REGION="West US"    #Customize region for Blob Storage
export ARO_MY_CONTAINER=aro-k10container4yong1      #Customize your container
export ARO_MY_OBJECT_STORAGE_PROFILE=aro-myazblob1  #Customize your profile name
export ARO_MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
# export MY_VMSIZE=Standard_D4as_v4   #Customize your VM size
# export MY_VMSIZE=Standard_D2as_v4   #Customize your VM size
# export MY_LOCATION=centralindia     #Customize your location
# export MY_REGION="Central India"    #Customize region for Blob Storage
# export K8S_VERSION=1.21             #Customize your Kubernetes Version

