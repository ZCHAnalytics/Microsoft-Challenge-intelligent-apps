# Create a new escalator function app with the Core Tools

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/a7856e4d-eb20-4671-8793-d041b3fe15ef)

## Run code on-demand with Azure Functions - Powershell

trigger - HTTP request

url: https://zch-escalator-functions.azurewebsites.net/api/DriveGearTemperatureService?code=xxxxxxxxxxxxxxxxxxxxxx

`curl <URL>`

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/5f1d1674-e925-45f2-a40d-5f50c2f24ff2)

## Secure HTTP triggers

`curl --header "Content-Type: application/json" --header "x-functions-key: <function-key>" --request POST --data "{\"name\": \"Azure Function\"}" https://zch-escalator-functions.azurewebsites.net/api/DriveGearTemperatureService?code=<key>`

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/158f97c3-5072-4c9d-a233-0d4274a13c45)

## Test business logic

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/c81f63c4-adc4-427b-afe7-094549da2f92)

## Functions Core Tool 

### Create a function locally using Core Tools

`func init loan-wizard`
enter 3 for node.
enter 1 for javascript.
`cd ~/loan-wizard`
`func new`
Enter 7 for HTTP trigger
`simple-interest`
`code .`

### Implement the simple-interest function

Replace the template simple-interest script with the the script that looks for parameters named principal, rate, and term in the query string of the HTTP request. 
It then returns the result of the simple interest calculation (principal * rate * term).

### Run the function in Cloud Shell

Run the following command to start the Functions host silently in the background.
`func start &> ~/output.txt &`
`code ~/output.txt`
`curl "http://localhost:7071/api/simple-interest?principal=5000&rate=.035&term=36" -w "\n"`

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/c2a9d62e-e223-4051-8044-de1790f08a4b)

## Publish a function to Azure using Core Tools

### Create a function app

RESOURCEGROUP=zch-function-rg
STORAGEACCT=learnstorage$(openssl rand -hex 5)
FUNCTIONAPP=learnfunctions$(openssl rand -hex 5)
az storage account create --resource-group "$RESOURCEGROUP" --name "$STORAGEACCT" --kind StorageV2 --location centralus
az functionapp create --resource-group "$RESOURCEGROUP" --name "$FUNCTIONAPP" --storage-account "$STORAGEACCT" --runtime node --consumption-plan-location centralus --functions-version 4

### Publish to Azure

`cd ~/loan-wizard`
`func azure functionapp publish "$FUNCTIONAPP" --force`

### Run the function
Run the following command to get the request URL:

`func azure functionapp list-functions "$FUNCTIONAPP" --show-keys`

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/f519ad56-c985-451d-8dbd-e73da4645c22)

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/dbb66639-c5e4-442d-8de2-40ee4b63a156)

Add `?principal=5000&rate=.035&term=36` to the end of the URL and select Enter. The result returned should be 6300.000000000001

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/774a2452-4fb5-4b07-86bc-1ebfe9ff7900)

