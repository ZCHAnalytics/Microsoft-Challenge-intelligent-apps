# Expose multiple Azure Function apps as a consistent API by using Azure API Management

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/def63f80-583b-4fad-855e-947d04c14912)

## Create functions

git clone https://github.com/MicrosoftDocs/mslearn-apim-and-functions.git ~/OnlineStoreFuncs
cd ~/OnlineStoreFuncs
bash setup.sh
The setup.sh script creates the two function apps in the sandbox resource group that are activated for this module. 
As the following graphic illustrates, each app hosts a single function - OrderDetails and ProductDetails. 
The script also sets up a storage account for the functions. The functions both have URLs in the azurewebsites.net domain. 
The function names include random numbers for uniqueness. 

![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/cb506cea-dd4c-4385-bdb7-8d1216caf7d0)

### Test the ProductDetails function
rom the list of functions for your function app, select ProductDetails. The ProductDetails Function pane appears.

In the Product Details menu, under Developer, select Code + Test. The Code + Test pane for the ProductDetails function appears, showing the contents of function.json file.
On the Input tab, in the HTTP method field dropdown list, select GET.

Under Query, Select Add parameter

In the Name field, enter id, and in the Value field, enter 3, and then select Run.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/2d9d5e3b-397e-417d-be7b-83f4666e1305)

Get Function URL:
https://productfunction47e149b706.azurewebsites.net/api/ProductDetails?code=xxxxxxxxxxxxxxx

### Expose function app as an API using Azure API Management
API Management field, select Create new. The Install API Management gateway 
When the API Management instance is deployed, select Link API.
The Import Azure Functions API Management service pane appears with the ProductDetails function highlighted.
Select Select to continue. The Create from Function App dialog box appears.

Change the API URL suffix value to products, and then select Create. Azure creates the API for the ProductDetails function. The Design tab for API Management pane for your function app appears.
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/920e94ed-a467-4f6c-b364-040b66c359e8)

### Test the OnlineStore products endpoint
You now have a ProductDetails API in the API Management instance that you created. Let's test that API with the API Management tools in Azure.
In the API Management pane of your function app, select the Test tab. The available operations for your API appear in the left column.

Select GET ProductDetails. The ProductDetails Console pane appears.

Under Query parameters, select Add parameter name:id, value: 1
![image](https://github.com/ZCHAnalytics/intelligent-apps-AKS-Functions-CosmosDB/assets/146954022/9b044cf3-fc5e-44ad-9252-a3532465e600)
.

