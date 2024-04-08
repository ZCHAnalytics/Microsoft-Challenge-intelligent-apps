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
  --enable-addons web_application_routing \
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

# Create Helm chart directory and files
CHART_DIR="kubernetes/contoso-website"
mkdir -p $CHART_DIR

# Create Chart.yaml
cat <<EOF > $CHART_DIR/Chart.yaml
apiVersion: v2
name: contoso-website
description: A Helm chart for deploying the Contoso website
version: 0.1.0
EOF

# Create values.yaml
cat <<EOF > kubernetes/contoso-website/values.yaml
image:
  registry: ${ACR_NAME}.azurecr.io
  name: contoso-website
  tag: latest

dns:
  zone: ${DNS_NAME}
EOF
# Create deployment.yaml
cat <<EOF > kubernetes/contoso-website/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: contoso-website
  namespace: {{ default "staging" .Release.Namespace }}
spec:
  selector:
    matchLabels:
      app: contoso-website
  template:
    metadata:
      labels:
        app: contoso-website
    spec:
      containers:
        - image: {{ .Values.image.repository }}/{{ .Values.image.name }}:{{ default "latest" .Values.image.tag }}
          name: contoso-website
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 250m
              memory: 256Mi
          ports:
            - containerPort: 80
              name: http
EOF
#Create service.yaml
cat <<EOF > kubernetes/contoso-website/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: contoso-website
  namespace: {{ default "staging" .Release.Namespace }}
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: http
      name: http
  selector:
    app: contoso-website
  type: ClusterIP
  
EOF
# create ingress.yaml
cat <<EOF > kubernetes/contoso-website/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: contoso-website
  namespace: {{ default "staging" .Release.Namespace }}

spec:
  ingressClassName: webapprouting.kubernetes.azure.com
  rules:
    - host: contoso-{{ default "staging" .Release.Namespace }}.{{ .Values.dns.name }}
      http:
        paths:
          - backend:
              service:
                name: contoso-website
                port:
                  name: http
            path: /
            pathType: Prefix  
EOF

echo "Installation concluded, copy these values and store them, you'll use them later in this exercise:"
echo "-> Resource Group Name: $RESOURCE_GROUP_NAME"
# echo "-> ACR Name: $ACR_NAME"
echo "-> ACR Name: $ACR_NAME.azurecr.io" # append `.azurecr.io` to ACR_NAME
echo "-> ACR Login Username: $ACR_USERNAME"
echo "-> ACR Password: $ACR_PASSWORD"
# Change incorrect name ACR_NAME to AKS_NAME
echo "-> AKS Cluster Name: $AKS_NAME"
echo "-> AKS DNS Zone Name: $DNS_NAME"
