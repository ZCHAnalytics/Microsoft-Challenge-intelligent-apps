#!/bin/bash

echo "Defining variables..."
export RESOURCE_GROUP_NAME=mslearn-gh-pipelines-$RANDOM
export AKS_NAME=contoso-video
export ACR_NAME=contosocontainerregistry$RANDOM

echo "Searching for resource group..."
az group create -n $RESOURCE_GROUP_NAME -l uksouth # Note the region

# Add location flag to ensure AKS is created in the same region as the resource group 
echo "Creating cluster..."
az aks create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $AKS_NAME \
  --node-count 1 \
  --enable-addons http_application_routing \
  --dns-name-prefix $AKS_NAME \
  --enable-managed-identity \
  --generate-ssh-keys \
  --node-vm-size Standard_B2s \
  --location uksouth

echo "Obtaining credentials..."
az aks get-credentials -n $AKS_NAME -g $RESOURCE_GROUP_NAME

echo "Creating ACR..."
az acr create -n $ACR_NAME -g $RESOURCE_GROUP_NAME --sku basic
az acr update -n $ACR_NAME --admin-enabled true

export ACR_USERNAME=$(az acr credential show -n $ACR_NAME --query "username" -o tsv)
export ACR_PASSWORD=$(az acr credential show -n $ACR_NAME --query "passwords[0].value" -o tsv)

az aks update \
    --name $AKS_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --attach-acr $ACR_NAME

export DNS_NAME=$(az network dns zone list -o json --query "[?contains(resourceGroup,'$RESOURCE_GROUP_NAME')].name" -o tsv)

# Thse commands won't work because: 
# a) deployment.yaml and ingress.yaml are located in different folders which have not been created; 
# b) these two files use placeholders referencing values.yaml file to create ACR_NAME and DNS_NAME values. 

# Solution 1 
# Change values in values.yaml file manually after the initialisation complete. and remove SED commands from init.sh as they are redundant. 
# This way, the deployment and ingress files will be automatically updated with values from values.yaml file
# Action for solution 1
# remove sed commands in init.sh 

# Option 2 Create values.yaml file and replace values with outputs from init.sh file
mkdir -p kubernetes/contoso-website
cat <<EOF > kubernetes/contoso-website/values.yaml
image:
  registry: ${ACR_NAME}.azurecr.io
  name: contoso-website
  tag: latest

dns:
  name: ${DNS_NAME}
EOF

echo "Installation concluded, copy these values and store them, you'll use them later in this exercise:"
echo "-> Resource Group Name: $RESOURCE_GROUP_NAME"
# echo "-> ACR Name: $ACR_NAME"
echo "-> ACR Name: $ACR_NAME.azurecr.io" # append `.azurecr.io` to ACR_NAME
echo "-> ACR Login Username: $ACR_USERNAME"
echo "-> ACR Password: $ACR_PASSWORD"
# Chnage incorrect name ACR_NAME to AKS_NAME
echo "-> AKS Cluster Name: $AKS_NAME"
echo "-> AKS DNS Zone Name: $DNS_NAME"
