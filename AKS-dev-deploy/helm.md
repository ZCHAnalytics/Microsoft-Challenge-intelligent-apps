Application and package management using Helm
Example scenario
Let's say you work for a major pet store company called Contoso Pet Supplies. Your company sells pet supplies to customers worldwide. The solution is built and deployed as microservices and includes several major applications:
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/4608842a-4cc5-4f34-a701-d784785c704a)

You use an Azure Kubernetes Service (AKS) cluster to host the pet store front solution. The DevOps team uses standard declarative YAML files to deploy various services in the solution. In the current deployment workflow, the development teams create the deployment files for each application. Next, the DevOps team updates the deployment files to reflect production configuration settings where required. The manual management of many YAML files is proving a risk to the teams when efficiently deploying, operating, and maintaining systems and procedures. The DevOps team wants to use a Kubernetes package manager to standardize, simplify, and implement reusable deployment packages for all apps in the store front solution.

## What is Helm?
Let's say your development team decides to deploy the pet store company website to Kubernetes. As part of the process, your team creates deployment, service, and ingress YAML-based files. You hardcode and maintain the information in each file for each target environment by hand. However, maintaining three files for each environment is cumbersome and increases in complexity as the application grows.

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/fac165a2-b1fc-486f-a536-b0fa0dce02ed)

Helm is a package manager for Kubernetes that combines all your application's resources and deployment information into a single deployment package.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/6c515390-ac3e-497a-bc8d-705966a7d5cf)

Helm uses four components to manage application deployments on a Kubernetes cluster:
- The Helm client
- Helm charts
- Helm releases
- Helm repositories
  
The Helm client is a client installed binary responsible for creating and submitting the manifest files required to deploy a Kubernetes application. The client is responsible for the interaction between the user and the Kubernetes cluster. In Azure, the Helm client is preinstalled in the Cloud Shell and supports all security, identity, and authorization features of Kubernetes.

 Note
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/b234bfae-83c7-4019-a390-643e384d8179)

A Helm chart is a templated deployment package that describes a related set of Kubernetes resources. It contains all the information required to build and deploy the manifest files for an application to run on a Kubernetes cluster.
File / Folder	Description
Chart.yaml	A YAML file containing the information about the chart.
values.yaml	The default configuration values for the chart.
templates/	A folder that contains the deployment templates for the chart.

A Helm release is the application or group of applications deployed using a chart. Each time you install a chart, a new instance of an application is created on the cluster. Each instance has a release name that allows you to interact with the specific application instance.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/484ac02e-0d26-4fa2-b164-880f99a3349d)

A Helm repository is a dedicated HTTP server that stores information on Helm charts. The server hosts a file that describes charts and where to download each chart.

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/e05866e8-a34c-4d2a-9d64-45e9a6c99e97)

## EXERCISE:
### 0. Setup the environment
git clone https://github.com/Azure-Samples/aks-store-demo.git
cd aks-store-demo
az group create --name rg-helm-solaris --location uksouth
Create an Azure container registry using `az acr create --resource-group rg-helm-solaris --name acrhelmsolaris --sku Basic`
Create an AKS cluster using `az aks create --resource-group rg-helm-solaris --name akshelmsolaris --node-count 2 --attach-acr acrhelmsolaris --generate-ssh-keys`
Connect to the AKS cluster using  `az aks get-credentials --resource-group rg-helm-solaris --name akshelmsolaris`
kubectl get nodes
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/229f6e7a-f554-415f-b6e7-35bd2d2888fe)

### 1. Create and install a Helm chart

Let's say your development team already deployed your company's pet store website to your AKS cluster. The team creates three files to deploy the website:

A deployment manifest that describes how to install and run the application on the cluster,
A service manifest that describes how to expose the website on the cluster, and
An ingress manifest that describes how the traffic from outside the cluster routed to the web app.
How does Helm process a chart?
The Helm client implements a Go language-based template engine that parses all available files in a chart's folders. The template engine creates Kubernetes manifest files by combining the templates in the chart's templates/ folder with the values from the Chart.yaml and values.yaml files.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/69c028e8-a260-4721-b87e-9666bb2d1554)

### 2. Deploy a Helm chart
helm install aks-store-demo ./charts/aks-store-demo

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/9fb20791-2ff7-48e4-9431-4dcf197d9829)
Validate that the pod is deployed using the kubectl get pods command
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/dd4219b0-27c9-4a49-aa8f-6547a879bb93)

### 3. Delete Helm Release 
helm delete aks-store-demo

### 4. Install a Helm chart with set values

4.1. Install the Helm chart using the helm install command with the --set parameter to set the replicaCount of the deployment template to five replicas.
helm install --set replicaCount=5 aks-store-demo ./aks-store-demo

### 5. Manage a Helm release
How to use functions in a Helm template
The syntax for a function follows the {{ functionName arg1 arg2 ... }} structure.

How to use pipelines in a Helm template
A pipeline allows to send a value, or the result of a function, to another function.
How to use conditional flow control in a Helm template - if
How to iterate through a collection of values in a Helm template - range 
How to control the scope of values in a Helm template - with 
How to Helm define chart dependencies 
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/f3116904-c4ea-4246-90ed-f636a6d61086)
How to upgrade a Helm release
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/2d6c005b-c3b8-4285-b505-57f9268f302a)
helm upgrade my-app ./app-chart
helm history my-app
How to roll back a Helm release - helm rollback my-app 2 




