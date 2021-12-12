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
