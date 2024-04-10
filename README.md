![image](https://github.com/ZCHAnalytics/Microsoft-Challenge-intelligent-apps-skills/assets/146954022/2b8f0e2d-4c75-4e21-803a-80ab78d089af)# Microsoft Cloud Skills Challenge - Intelligent Apps Skills 

![image](https://github.com/ZCHAnalytics/Microsoft-Challenge-intelligent-apps-skills/assets/146954022/4cf9dc24-d296-4fa6-adab-8ce9040f1d82)

Core technologies: Azure Functions, Azure API Management, Azure Kubernetes Service, GitHub Actions and GitHub Copilot, Cosmos DB, container orchestration, 

## Deploy and manage a statefull application by using Azure Cosmos DB and Azure Kubernetes Service
Scenario: a freight company thats uses ships to transport goods across the globe. The Operations Department uses a small system that tracks where all the ships are docked. Due to staff increases, the company decided to move this system to Kubernetes.
Tasks: manage access to dabatabase built through a separate backend; determine how to manage database access in the distributed environment; and how to deploy a new database to support this critical applilcation.

Verify the database was successfully created: `az cosmosdb mongodb database list --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP -o table`. Output looks like this: 
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/d79d33b6-7750-44ca-9df5-b8b746a89d89)

Now, we've created an external state to store all the data from the ship manager application. We will create the AKS resource to store the application itself.

Test the configuration with `kubectl get nodes`
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/bc2669bc-af94-4602-a4f8-6228f93f80fb)

#### Deploy the back-end API

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/50da3aba-5a0c-4285-9495-e91634af6931)

### Make the application available

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/8fb4bc5a-c031-4b89-b105-6ef783e84769)

Now the API can be accessed through the host name that was pasted in the ingress resource (The Azure DNS zone resource can take up to five minutes to complete the DNS detection): 

Check the ingress status by querying Kubernetes for the available ingresses using the `kubectl get ingress` command.
Output: no address.

NAME                   CLASS                                HOSTS                                                              ADDRESS   PORTS   AGE
ship-manager-backend   webapprouting.kubernetes.azure.com   ship-manag-rg-ship-manager-9e04f9-gjfu5q0a.hcp.uksouth.azmk8s.io             80      68m

This seems to be a common problem as Kubernetes needs to know the class of ingress controller. There are many various suggestions on stackoverflow and Kubernetes website  but the one from azure GitHub did the trick :  https://azure.github.io/Cloud-Native/cnny-2023/fundamentals-day-2/

Enable the web application routing add-on in our AKS cluster with the following command:
`az aks addon enable --name <YOUR_AKS_NAME> --resource-group <YOUR_AKS_RESOURCE_GROUP> --addon web_application_routing`

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/d4dd72bd-8c98-42d9-a4a1-f9ca11a5d6ff)

#### Deploy the front-end interface

zulfia [ ~ ]$ vim frontend-deploy.yml 
zulfia [ ~ ]$ kubectl apply -f frontend-deploy.yml
deployment.apps/ship-manager-frontend created
configmap/frontend-config created
zulfia [ ~ ]$ vim frontend-network.yml
zulfia [ ~ ]$ kubectl apply -f frontend-network.yml
service/ship-manager-frontend created
ingress.networking.k8s.io/ship-manager-frontend created
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/18b41f54-e961-45d3-b83a-2fd142f947f8)

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/6207140b-8f8f-4300-83f6-c1b1190c989d)

## Work with Cosmos DB

In Azure portal, create a Cosmos DB for NoSQL account (named solarisdb2024), serverless. Add database called ToDoList and a container called Items via Data Explorer. 

We then add data:

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/9d172fa6-231a-4d29-9724-58a665076823)

and clean up after exercise/


## Code with GitHub Codespaces 

## Build a minigame with GitHub Copilot and Python

## Orchestrate containers for cloud-native applications with AKS

## Create serverless logic with Azure Functions

## Develop, test and publish  Azure Functions by using Azure Functions Core Tools

## Develop, test, and deploy Azure Functions with Visual Studio

## Expose multiple Azure Function apps as a consistent API by using Azure API Management

##

Stateful app with Cosmos DB and Azure Kubernetes Service
Azure Kubernetes Service deployment pipeline with GitHub Actions
Code with Codespaces - Challenge projectL Build a minigame with GitHub Copilot and Python
Orchestrate containers for cloud-native apps with AKS
Serverless logic with Azure Functions
Develop, test and publish Azure Functions by using Azure Functions Core Tools
Develop, test and publish Azure Functions with Visual Studio
Expose multiple Azure Function apps as a consistent API using Azure API Management

