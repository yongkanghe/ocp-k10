echo "-------Install oc client, create an app registration"
cd ~/ocp-k10/aro-k10
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -zxvf openshift-client-linux.tar.gz oc
ln -s oc kubectl

cat ~/.bashrc | grep aro-k10
if [ `echo $?` -eq 1 ]
then
  echo 'export PATH=$PATH:~/ocp-k10/aro-k10' >> ~/.bashrc
fi

source ~/.bashrc

rm openshift-client-linux.tar.gz

./createapp.sh

echo "" | awk '{print $1}'
echo -n "Click the link to Log into Red Hat Cloud Console https://console.redhat.com/openshift/install/pull-secret"
# echo -n "\nClick OpenShift, Click Downloads, Scroll down to the bottom"
echo "" | awk '{print $1}'
echo -n "Click "Copy pull secret" button, Paste your pull secret and press [ENTER]: "
read pullsecret
echo "" | awk '{print $1}'
echo $pullsecret > pull-secret.txt

clear

echo "-------oc installed, App Registration has been created"
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'