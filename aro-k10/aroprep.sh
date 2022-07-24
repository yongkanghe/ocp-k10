echo "-------Install oc client, create an app registration"
cd ~/ocp-k10/aro-k10
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -zxvf openshift-client-linux.tar.gz oc
ln -s oc kubectl

cat ~/.bashrc | grep aro-k10
if [ `echo $?` -eq 1 ]
then
  echo 'export PATH=$PATH:~/ocp-k10/aro-k10' >> ~/.bashrc && source ~/.bashrc
fi

rm openshift-client-linux.tar.gz

./createapp.sh

echo -n "\nLog into Red Hat Cloud Console https://cloud.redhat.com"
echo -n "\nClick OpenShift, Click Downloads, Scroll down to the bottom"
echo -n "\nClick Copy button under Tokens section, Paste your pull secret and press [ENTER]: "
read pullsecret
echo "" | awk '{print $1}'
echo $pullsecret > pull-secret.txt

clear

echo "-------oc installed, App Registration has been created"
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'