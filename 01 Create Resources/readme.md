# Data Share Synapse Pipeline - 01 Create Resources

The files in this location are to help build the resources we'll use in your Azure subscription.  The script will create the resources below.  It will check for the existence of the items first so you can specify existing resources in the paramfile.json.  

## File Inventory
You need to download and save the files listed here to your local machine.  
Filename  | Details
------------- | -------------
00 - PreReqCheck.ps1  | PoSH script to help with pre-reqs
01 - Create Resources DataShare.ps1  | Posh script to create items specified in Azure
02 - GrantStorageRights.ps1 | Posh script to grant rights required 
paramfile.json | Parameter file containing all details passed to PoSH scripts 

You will need to update the paramfile.json file before you run the PowerShell scripts above.  It is used to drive all the PowerShell scripts and is the only file that needs input/editing.  Below is a listing of the variables within the paramfile and a description.  Values above line 24 within the file need updating.  Lines 24 and below do not need editing. 

## Paramfile Variable Details
paramfile value | Details
| :--- | :--- 
SubscriptionId | Azure Subscription ID to create resources
tenantid | Azure tenant id 
resourceGroupName | Name of resource group 
resourceGroupLocation | Region to create items in Azure (i.e. East US2)
azsynapsename | Name of Synapse workspace to create items 
azstoragename | ADLS will be used by Synapse workspace (I keep mine separated from data lake storage) 15 or less characters
containersys | Container to create in above ADLS storage acct
ManagedVirtualNetwork | name for managed vnet 
firewallrulename | name for a firewall rule to allow your local IP to connect 
azstoragename2 | ADLS data lake storage account to land processed parquet files 
containername1 | raw landing container name if using sample 
containername2 | container to land processed parquet files 
adminuser | AAD account that can create resources in Azure 
akvname | Name of Azure Key Vault to create or use 
akvsecret1 | Name of secret to create in AKV containing the connection string to source storage account 
akvsecret2 | Name of 2nd secret to create in AKV containing the connection string to source storage account 
LinkedServiceName1 | Linked Service name pointing to azstoragename2 above
LinkedServiceName2 | Linked Service name pointing to akvname above
LinkedServiceName3 | Linked Service name pointing to storage account containing csv source
DatasetName1 | Dataset name for dynamic storage source
DatasetName2 | Dataset name for ADLS to compile data in parquet files in azstoragename2
PipelineName1 | Pipeline name to extract data

## Steps to create resources in Azure  

1. Download all the files contained in this folder and save to a local folder location.  

2. Open the 00 - PreReqCheck.ps1 file in your preferred client to run PowerShell.  Visual Studio Code can be used for example (https://code.visualstudio.com/) or the PowerShell ISE.  You can step through and run selections of the code to check and validate PowerShell version and required modules are installed.
  
![alt text](https://github.com/hfoley/EDU/blob/master/images/VSCodeRunSelection.jpg?raw=true)

3. Open and update all the values needed within the paramfile.json based on the table above for reference.  Anything that contains <> requires your input.  Replace all the values including the <> within the " ".  
	![alt text](https://github.com/hfoley/EDU/blob/master/images/EditingParamFile.jpg?raw=true)
4.  Run the PowerShell script 01 - Create Resources DataShare.ps1 by running the following command in the PowerShell client of choice

	`& "C:\localfolder\01 - Create Resources DataShare.ps1" -filepath "C:\localfolder\paramfile.json`
	
	a. You will be prompted to login to Azure.  Login as someone allowed to create items in the Azure subscription. (Note: you may see warnings if you are tied to multiple tenants) 
	
	b. You'll be prompted for a user and password.  This text you type will become your SQL admin account for the Synapse workspace username and password. 
		<insert pic>
	c. The script will detail out the beginning of the creation of the resources.  For example if the resource group you specify in the paramfile.json for variable resourceGroupName doesn't exist, it will begin creating it and will write text below to the PowerShell screen.  
			
	The resource group creation script was started  8/30/2021 8:31:59 PM
	Resource group 'resourceGroupName' doesn't exist and will be created
	
	d. It will continue creating or skipping the creation of the components. 
	
	e. You will then be prompted for text to input for akvsecret1 and akvsecret2.  Input into the text box the connection string for the storage account containing the data source CSVs.  You can get to the connection string text in the Access Keys panel in the Azure portal for the storage account.  https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal  



5.  Run 02 - GrantStorageRights.ps1 script by running the following command in the PowerShell client of choice

	`& "C:\localfolder\02 - GrantStorageRights.ps1" -filepath "C:\localfolder\paramfile.json`

6.  Validate all the resources were successfully created in your Azure environment.  

Continue on to [02 Create Pipeline Parts](https://github.com/hfoley/DataSharePipeline/tree/main/02%20Create%20Pipeline%20Parts) to build the pipeline and related parts within the Synapse workspace 

