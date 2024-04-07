

1. Running init.sh 
`bash init.sh`

1.1. The bash file did not specify the regions for all resources. So at first attempt, the resources were created across the globe. 
in `az aks create` I specify the region to be the same as in resource group: 
`  --location uksouth`

1.2. The later steps create the filepath for kubernetes file which are missing from the init.sh, so I correct them just in case it will cause any issues later:

These commands are not needed as values are created in values.yaml file 
sed -i '' 's+!IMAGE!+'"$ACR_NAME"'/contoso-website+g' kubernetes/deployment.yaml
sed -i '' 's+!DNS!+'"$DNS_NAME"'+g' kubernetes/ingress.yaml


echo "Installation concluded, copy these values and store them, you'll use them later in this exercise:"
echo "-> Resource Group Name: $RESOURCE_GROUP_NAME"
echo "-> ACR Name: $ACR_NAME"

echo "-> ACR Name: $ACR_NAME.azurecr.io" # append `.azurecr.io` to ACR_NAME
echo "-> ACR Login Username: $ACR_USERNAME"
echo "-> ACR Password: $ACR_PASSWORD"

Change incorrect name ACR_NAME to AKS_NAME
echo "-> AKS Cluster Name: $AKS_NAME"
echo "-> AKS DNS Zone Name: $DNS_NAME"


The Dockerfile needed to be updated as well as nginx, node.js and hugo versions and/or links were out of date.

Checking the results with az group list -o table shows that all resources are now in the same region and status is 'succeeded'. 
The command `az acr list -o table` shows that Azure Container Registry is now live and kicking.

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/2f41fec7-ac5b-4abc-aef1-12413cb82dc2)

check

UNIT 4 of 11

![image](https://github.com/ZCHAnalytics/mslearn-aks-deployment-pipeline-github-actions/assets/146954022/5e4c467e-c9a8-4caf-9fca-5ad13ced637b)

UNIT 6 of 11 build-staging.yaml
SECRETS NAMES
![image](https://github.com/ZCHAnalytics/mslearn-aks-deployment-pipeline-github-actions/assets/146954022/ecb972f1-6ae8-4d7d-90fd-6f49cd8d4420)

Run successful: 
![image](https://github.com/ZCHAnalytics/mslearn-aks-deployment-pipeline-github-actions/assets/146954022/f1fc6f1c-d15a-4df9-9464-76411a9f063a)

Check: 
`az acr repository list --name contosocontainerregistry4284.azurecr.io -o table`

![image](https://github.com/ZCHAnalytics/mslearn-aks-deployment-pipeline-github-actions/assets/146954022/c54f3cd9-d1aa-44b2-b030-1799dfb06e44)

UNIT 7 of 11 - production
build-production.yaml file 

tags
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/6e005c46-4e23-4b4a-87ca-bd08ed37f054)

az acr repository show-tags --repository contoso-website --name $ACR_NAME -o table

Another helpful command for troubleshooting: zulfia [ ~/mslearn-aks-deployment-pipeline-github-actions ]$ git ls-remote --tags https://github.com/ZCHAnalytics/mslearn-aks-deployment-pipeline-github-actions.git
git config --global credential.helper store

UNIT 9 of 11 - Helm chart

deployment.yaml - correct ACR name
spec:
      containers:
        - image: {{ .Values.image.registry }}.azurecr.io/{{ .Values.image.name }}:{{ default "latest" .Values.image.tag }}

      containers:
        - image: {{ .Values.image.registry }}/{{ .Values.image.name }}:{{ default "latest" .Values.image.tag }}


ingress.yaml - change annotation to spec
spec:
  ingressClassName: addon-http-application-routing
  rules:

UNIT 10 of 11

-- Run helm upgrade \
Release "contoso-website" does not exist. Installing it now.
Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: [apiVersion not set, kind not set]
Error: Process completed with exit code 1.

Run helm upgrade \
Release "contoso-website" does not exist. Installing it now.
Error: release contoso-website failed, and has been uninstalled due to atomic being set: 1 error occurred:
	* Ingress.extensions "contoso-website" is invalid: spec.rules[0].host: Invalid value: "contoso-staging.": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')

I ended up moving the dot to inside the first placeholder, straight after 'staging' word. :) 
- host: "contoso-{{ trim (default "staging." .Release.Namespace) }}{{ .Values.dns.name }}" 
no website:
kubectl get namespaces


