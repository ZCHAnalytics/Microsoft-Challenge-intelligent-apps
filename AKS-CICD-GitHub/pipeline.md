# AKS deployment pipeline with GitHub Actions

Scenario:  A video production company migrated its technology stack to AKS. To reduce time and effort building container images and deploying applications, we investigate using pipelines to deploy AKS workloads.

I need one pipeline for development and another one for production that are triggered by different events. 

1) a tagged push to the main branch (to production) 
2) a non-tagged push to the main branch (to staging environment).
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/51427827-6afd-400e-85c0-1c160d94322b)

### 0. Set up Project Environment in Azure Cloud shell:
Clone the GitHub Repo and inside it, run the init.sh file. The bash file did not specify the regions for all resources. So at first attempt, the resources were created across the globe. So I edited the file. 
The Dockerfile needed to be updated as well as nginx, node.js and hugo versions and/or links were out of date.

Checking the results with `az group list -o table` shows that all resources are now in the same region and status is 'succeeded'. 
The command `az acr list -o table` shows that Azure Container Registry is now live and kicking.

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/bfc2366a-1337-4006-b91f-5427316ac97e)


### 1. Design a Staging Pipeline
Now I create a pipeline by adding a new GitHub Actions workflow with file `build-staging.yml` and commit changes. The run failed because the environmental variables are not added to GitHub Actions, which I will do straight away.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/53325f9e-7923-4bea-91e2-43e0fa3afa38)

Now we have a GitHub Actions staging pipeline that builds an application image and pushes it to Azure Container Registry.
https://learn.microsoft.com/en-us/training/modules/aks-deployment-pipeline-github-actions/media/3-pipeline-5-deploy.png

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/5e554141-a288-4f56-9e0a-b6536f22a537)

### 2. Design production pipeline 
We configure a new workflow in `build-production.yaml` file. 

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/5a9e53f6-0feb-406b-b2dd-b0d6b8414c17)

git tag -a v2.0.0 -m 'My first tag'
git push --tags

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/0955285f-b75c-450f-8892-bab23437d8ed)


![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/d9aaaf58-417f-460c-894e-9742c20faaaa)

Check:
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/d69dc042-d5c0-4f06-819e-35b808c4d41a)


### 3. Helm Chart

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/b8527401-388e-4e89-9eb3-7457f0bdbaf8)

- Generate a boilerplate Helm template in the kubernetes directory of the repository.
- Configure the Chart.yaml
- Configure the deployment.yaml file in the kubernetes/templates folder.
- Add content to the values.yaml file (inc dns zone)
- Configure the service.yaml file in the templates folder.
- Configure the ingress.yaml file 

### 4. Add deployment job to the staging pipeline
- Add deploy job to build-staging.yaml
- Add the Install Helm step
- Add the Azure Login authentication step
- Set up Open ID Connect (OIDC) - `az ad sp create-for-rbac --scopes /subscriptions/$SUBSCRIPTION_ID --role Contributor` - Set the secrets in Github Actions
  ![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/ef855654-7f89-4456-8492-55f7a57b3df8)

- Add federated credentials in azure portal Add federated credentials

- ![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/f551d016-0493-4690-9401-fcf8dbff76be)

- Add the Run Helm Deploy step
- Commit the changes and test the staging deployment

AlLl done!

### 5. Run the deployment on production
- build-production.yaml
- Production changes - azure portal - update the federated certificate with the corresponding tag version - increment the tag number to a new v.x.x.x such as v.2.0.1
`git tag -a v2.0.1 -m 'Create new production deployment' && git push --tags`

Check: After the workflow succeeds, to test the production deployment, go to contoso-production.<aks-dns-zone-name> in your browser and confirm that the website appears.


### 6. Clean up the resources after testing the workflows or there will be an unexpectyed bill!
