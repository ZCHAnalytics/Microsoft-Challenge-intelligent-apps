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
