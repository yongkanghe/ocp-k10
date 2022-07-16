echo "-------Install oc client, create an app registration"
cd ~/aro-k10
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -zxvf openshift-client-linux.tar.gz
echo 'export PATH=$PATH:~/ocp-k10/aro-k10' >> ~/.bashrc && source ~/.bashrc
rm openshift-client-linux.tar.gz

AZURE_SUBSCRIPTION_ID=$(az account list --query "[?isDefault][id]" --all -o tsv)
az ad sp create-for-rbac --name https://aks4yong1-k10-app --role Contributor --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID -o json > aro4yong1app

clear

echo "-------oc installed, App Registration has been created"
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'