# Data Share Synapse Pipeline - 03 Sample Data

The files in this location are to help build out a sample source dataset to run through the pipeline.  These files that are stored here were downloaded from 	https://healthdata.gov/dataset/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/4cnb-m4rz.  These csv files contain hospitalization data.  

## File Inventory
You need to download and store these files in an Azure storage account 

Filename  | Details
------------- | -------------
00 - PreReqCheck.ps1  | PoSH script to help with pre-reqs
01 - Create Resources DataShare.ps1  | Posh script to create items specified in Azure
02 - GrantStorageRights.ps1 | Posh script to grant rights required 
paramfile.json | Parameter file containing all details passed to PoSH scripts 

You will need to update the paramfile.json file before you run the PowerShell scripts above.  It is used to drive all the PowerShell scripts and is the only file that needs input/editing.  Below is a listing of the variables within the file and a description.  Values above line 24 need updating.  Lines 24 and below do not need editing. 

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

5.  Run 02 - GrantStorageRights.ps1 script by running the following command in the PowerShell client of choice

	`& "C:\localfolder\02 - GrantStorageRights.ps1" -filepath "C:\localfolder\paramfile.json`

6.  Validate all the resources were successfully created in your Azure environment.  

Continue on to [02 Create Pipeline Parts](https://github.com/hfoley/DataSharePipeline/tree/main/02%20Create%20Pipeline%20Parts) to build the pipeline and related parts within the Synapse workspace 

