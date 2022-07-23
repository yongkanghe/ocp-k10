echo "-------Install oc client, create an app registration"
cd ~/aro-k10
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -zxvf openshift-client-linux.tar.gz
echo 'export PATH=$PATH:~/ocp-k10/aro-k10' >> ~/.bashrc && source ~/.bashrc
rm openshift-client-linux.tar.gz

~/ocp-k10/aro-k10/createapp.sh

echo -n "Log into Red Hat Cloud Console https://cloud.redhat.com, Click OpenShift, Click Downloads, Scroll down to the bottom, Click Copy button under Tokens section, Paste your pull secret and press [ENTER]: "
read pullsecret
echo "" | awk '{print $1}'
echo $pullsecret > pull-secret.txt

clear

echo "-------oc installed, App Registration has been created"
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'