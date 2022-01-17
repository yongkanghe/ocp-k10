. ./setenv.sh

# oc config use-context $(oc config get-contexts -o name | grep violet)

echo k10migration4yong1 > k10_migration_bucketname
export MY_OBJECT_STORAGE_PROFILE=myibmcos1-migration
export AWS_ACCESS_KEY_ID=$(cat ../ocp4yong1-ibm-k10/ibmaccess | head -1 | sed -e 's/\"//g') 
export AWS_SECRET_ACCESS_KEY=$(cat ../ocp4yong1-ibm-k10/ibmaccess | tail -1 | sed -e 's/\"//g')

echo '-------Creating a IBM COS profile secret'
kubectl create secret generic k10-ibm-migration-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

echo '-------Creating an IBM COS profile'
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
        name: k10-ibm-migration-s3-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $(cat k10_migration_bucketname)
      objectStoreType: S3
      region: $MY_REGION
      endpoint: s3.$MY_REGION.cloud-object-storage.appdomain.cloud
EOF
