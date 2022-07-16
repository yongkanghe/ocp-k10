AZURE_SUBSCRIPTION_ID=$(az account list --query "[?isDefault][id]" --all -o tsv)
az ad sp create-for-rbac --name https://aks4yong1-k10-app --role Contributor --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID -o json > aro4yong1app
