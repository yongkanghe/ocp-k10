echo "-------Install Helm if not exist"
which helm
if [ `echo $?` -eq 1 ]; then
  #helm init --stable-repo-url https://charts.helm.sh/stable
  wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
  tar zxf helm-v3.7.1-linux-amd64.tar.gz
  mkdir ~/bin
  mv linux-amd64/helm ~/bin
  rm helm-v3.7.1-linux-amd64.tar.gz 
  rm -rf linux-amd64 
  export PATH=$PATH:~/bin
fi

echo -n "Enter your AWS Access Key ID and press [ENTER]: "
read AWS_ACCESS_KEY_ID
echo "" | awk '{print $1}'
echo $AWS_ACCESS_KEY_ID > awsaccess
echo -n "Enter your AWS Secret Access Key and press [ENTER]: "
read AWS_SECRET_ACCESS_KEY
echo $AWS_SECRET_ACCESS_KEY >> awsaccess
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'
