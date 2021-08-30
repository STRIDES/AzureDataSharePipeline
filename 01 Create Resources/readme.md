# Data Share Synapse Pipeline - 01 Create Resources

The files in this location are to help build the resources we'll use in your Azure subscription.  The script will create the resources below.  It will check for the existence of the items first so you can specify existing resources in the paramfile.json.  

## File Inventory

Filename  | Details
------------- | -------------
00 - PreReqCheck.ps1  | PoSH script to help with pre-reqs
01 - Create Resources DataShare.ps1  | Posh script to create items specified in Azure
02 - GrantStorageRights.ps1 | Posh script to grant rights required 
paramfile.json | Parameter file containing all details passed to PoSH scripts 

## Paramfile Variable Details
paramfile value | Details
| :--- | ---: 
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


## Steps to create resources in Azure  

1. Download all the files contained in this folder and save to a local folder location.  

2. Open the 00 - PreReqCheck.ps1 file in your preferred client to run PowerShell.  Visual Studio Code can be used for example (https://code.visualstudio.com/) or the PowerShell ISE.  You can step through and run selections of the code to check and validate PowerShell version and required modules are installed.
  
![alt text](https://github.com/hfoley/EDU/blob/master/images/VSCodeRunSelection.jpg?raw=true)

3. Open and update all the values needed within the paramfile.json.  Anything that contains <> requires your input.  Replace all the values including the <> within the " ".  
	![alt text](https://github.com/hfoley/EDU/blob/master/images/EditingParamFile.jpg?raw=true)
4.  Run the PowerShell script 01 - Create Resources DataShare.ps1 by running the following command in the PowerShell client of choice

	`& "C:\localfolder\01 - Create Resources DataShare.ps1" -filepath "C:\localfolder\paramfile.json`

5.  Run 02 - GrantStorageRights.ps1 script by running the following command in the PowerShell client of choice

	`& "C:\localfolder\02 - GrantStorageRights.ps1" -filepath "C:\localfolder\paramfile.json`
	

Continue on to [02 Sample Data](https://github.com/hfoley/DataSharePipeline/tree/main/02%20Create%20Pipeline%20Parts) to build the pipeline and related parts within the Synapse workspace 

