# intelligent-apps-AKS-Functions-CosmosDB
cloud-native apps on Azure, Azure Functions, Azure Kubernetes Service (AKS), GitHub Copilot and prompt engineering

## Deploy and manage a statefull application by using Azure Cosmos DB and Azure Kubernetes Service
Scenario: a freight company thats uses ships to transport goods across the globe. The Operations Department uses a small system that tracks where all the ships are docked. Due to staff increases, the company decided to move this system to Kubernetes.
Tasks: manage access to dabatabase built through a separate backend; determine how to manage database access in the distributed environment; and how to deploy a new database to support this critical applilcation.

### Create a resource group in a bash cloud shell in Azure portal in East US called rg-ship-manager:
`az group create --name rg-ship-manager --location eastus`

While it is possible to handle state in Kubernetes, it is not recommended. To make a highly-available application state, we'll externalize the state to Azure Cosmos DB application that specializes in dealing with external state. For convenience, we create bash variables to store the Azure Cosmos DB account name and the resource group name for use throughout the rest of the module:
` export RESOURCE_GROUP=rg-ship-manager; export COSMOSDB_ACCOUNT_NAME=contoso-ship-manager-$RANDOM `

1. Create a new Azure Cosmos DB account using the command: `az cosmosdb create --name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --kind MongoDB`

2. Create a new database named `contoso-ship-manager`: `az cosmosdb mongodb database create --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --name contoso-ship-manager`

3 . Verify the database was successfully created: `az cosmosdb mongodb database list --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP -o table`. Output looks like this: 
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/d79d33b6-7750-44ca-9df5-b8b746a89d89)

Now, we've created an external state to store all the data from the ship manager application. We will create the AKS resource to store the application itself.

### Create an AKS cluster named `ship-manager-cluster`
Again, we create a bash variable to store the cluster name `AKS_CLUSTER_NAME=ship-manager-cluster`and then create a cluster:
`az aks create --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --node-count 3 --generate-ssh-keys --node-vm-size Standard_B2s --enable-addons http_application_routing`.

Download the kubectl configuration using the command: `az aks get-credentials --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP`

Test the configuration with `kubectl get nodes`
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/bc2669bc-af94-4602-a4f8-6228f93f80fb)

### Deploy the application 
We need to create yaml files to deploy to Kubernetes
#### Deploy the back-end API
Get the CosmosDB database connection string: `az cosmosdb keys list --type connection-strings -g $RESOURCE_GROUP -n $COSMOSDB_ACCOUNT_NAME --query "connectionStrings[0].connectionString" -o tsv`

Create a yaml file and add the deployment specification using nano or vim or other editor: `vim backend-deploy.yaml`

## Work with Cosmos DB

## Monitor GitHub events by using a webhook with Azure Functions

## AKS deployment pipeline with GitHub Actions

## Code with GitHub Codespaces 

## Build a minigame with GitHub Copilot and Python

## Orchestrate containers for cloud-native applications with AKS

## Create serverless logic with Azure Functions

## Develop, test and publish  Azure Functions by using Azure Functions Core Tools

## Develop, test, and deploy Azure Functions with Visual Studio

## Expose multiple Azure Function apps as a consistent API by using Azure API Management

##
