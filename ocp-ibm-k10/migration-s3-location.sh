. ./setenv.sh

if [ ! -f awsaccess ]; then
  echo -n "Enter your AWS Access Key ID and press [ENTER]: "
  read AWS_ACCESS_KEY_ID
  echo "" | awk '{print $1}'
  echo $AWS_ACCESS_KEY_ID > awsaccess
  echo -n "Enter your AWS Secret Access Key and press [ENTER]: "
  read AWS_SECRET_ACCESS_KEY
  echo $AWS_SECRET_ACCESS_KEY >> awsaccess
fi

export MY_REGION=ap-southeast-1
export MY_OBJECT_STORAGE_PROFILE=myaws3-migration
export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1)
export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1)
#echo k10migration4yong1-$(cat awsaccess | (read -n 2 i; echo $i;))$(date +%m%d) | awk '{print tolower($0)}' > k10_migration_bucketname
echo k10migration4yong1 > k10_migration_bucketname
export MY_OBJECT_STORAGE_PROFILE=myaws3-migration

echo '-------Creating a S3 profile secret'
kubectl create secret generic k10-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

echo '-------Creating a S3 profile'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Profile
metadata:
  name: $MY_OBJECT_STORAGE_PROFILE
  namespace: kasten-io
spec:
  type: Location
  locationSpec:
    credential:
      secretType: AwsAccessKey
      secret:
        apiVersion: v1
        kind: Secret
        name: k10-s3-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $(cat k10_migration_bucketname)
      objectStoreType: S3
      region: $MY_REGION
EOF
