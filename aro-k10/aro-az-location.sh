. ./setenv.sh

echo '-------Create a Azure Blob Storage profile secret'
kubectl create secret generic k10-aro-azure-secret \
      --namespace kasten-io \
      --from-literal=azure_storage_account_id=$ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID \
      --from-literal=azure_storage_key=$(cat aro_az_storage_key)

echo '-------Creating a Azure Blob Storage profile'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Profile
metadata:
  name: $ARO_MY_OBJECT_STORAGE_PROFILE
  namespace: kasten-io
spec:
  type: Location
  locationSpec:
    credential:
      secretType: AzStorageAccount
      secret:
        apiVersion: v1
        kind: Secret
        name: k10-aro-azure-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $ARO_MY_PREFIX-$ARO_MY_CONTAINER
      objectStoreType: AZ
      region: $ARO_MY_REGION
EOF
