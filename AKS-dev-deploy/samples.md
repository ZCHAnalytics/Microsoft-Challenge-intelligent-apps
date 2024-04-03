## Create an AKS cluster

$ export RESOURCE_GROUP=rg-contoso-video
$ export CLUSTER_NAME=aks-contoso-video
$ export LOCATION=eastus

### System node:
az group create --name=$RESOURCE_GROUP --location=$LOCATION
az aks create --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --node-count 2 --generate-ssh-keys --node-vm-size Standard_B2s --network-plugin azure --windows-admin-username localadmin

### Node pool for apps and workloads
az aks nodepool add --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --name uspool --node-count 2 --node-vm-size Standard_B2s --os-type Windows

### Link with Kubectl
az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP
$ kubectl get nodes

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/a2cc2e3f-87eb-400c-82d1-19b1356974b1)

## Deploy an application on AKS cluster
The website is a static website with an underlying technology stack of HTML, CSS, and JavaScript. It doesn't receive as many requests as the other services and provides us with a safe way to test deployment options.

touch deployment.yaml

# deployment.yaml
apiVersion: apps/v1 # The API resource where this workload resides
kind: Deployment # The kind of workload we're creating
metadata:
  name: contoso-website # This will be the name of the deployment
  
A deployment wraps a pod. You make use of a template definition to define the pod information within the manifest file. The template is placed in the manifest file under the deployment specification section.
  spec:
  template: # This is the template of the pod inside the deployment
    metadata: # Metadata for the pod
      labels:
        app: contoso-website

A pod wraps one or more containers. All pods have a specification section that allows you to define the containers inside that pod.
    spec:
      containers: # Here we define all containers
        - name: contoso-website
        It's a good practice to define a minimum and a maximum amount of resources that the app is allowed to use from the cluster. You use the resources key to specify this information.
                  resources:
            requests: # Minimum amount of resources requested
              cpu: 100m
              memory: 128Mi
            limits: # Maximum amount of resources requested
              cpu: 250m
              memory: 256Mi
              The last step is to define the ports this container exposes externally through the ports key. The ports key is an array of objects, which means that a container in a pod can expose multiple ports with multiple names.
                        ports:
            - containerPort: 80 # This container exposes port 80
              name: http # We named that port "http" so we can refer to it later
              Finally, add a selector section to define the workloads the deployment manages. The selector key is placed inside the deployment specification section of the manifest file. Use the matchLabels key to list the labels for all the pods managed by the deployment.

  selector: # Define the wrapping strategy
    matchLabels: # Match all pods with the defined labels
      app: contoso-website # Labels follow the `name: value` template
