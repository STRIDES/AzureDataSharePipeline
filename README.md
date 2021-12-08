# Data Sharing - Synapse Analytics Pipeline Solution Pattern 

This solution is to help build out a process to collect data contained in an Azure storage account, internal or external.  These PowerShell scripts will build out all the the components of this architecture using a Synapse Analytics workspace, Azure Data Lake storage, and an Azure Key Vault.  It will also build out the parameter driven pipelines to automate the sharing of the data (example uses CSVs) across environments.  **GIANT SECURITY DISCLAIMER**: Due to what this does, it's not the most secure way to setup an environment!!  You need to verify that you're going to be allowed to do this in your Azure environment and potentially plan the location based on policies/etc.  You will need the connection string for the storage account to pull data from so there will need to clearance and blessings on both sides of this solution.  The connection string contains the storage keys which is the highest level of access you can grant at a full storage level.  You may need to setup separate subscriptions/storage accounts that aren't under restrictions or policies such as HIPPA/etc.  **PROCEED WITH CAUTION AND MAKE SURE YOU'VE GOTTEN APPROVAL FROM YOUR AZURE ADMINS AND DATA GOVERNANCE ENTITIES!**  

The architecture of the solution diagrammed below.  


![alt text](https://github.com/hfoley/EDU/blob/master/images/Hope%20Data%20Share%20Architecture.jpg?raw=true)

## Solution Details - Overview of what the solution is and what it does 
1. This full solution will create an Azure Synapse Analytics workspace, 2 ADLS Gen 2 storage accounts, and an Azure Key Vault.   
2. This also builds a parameterized pipeline that can reach into storage accounts to grab csv files and process them.  It will process them and land them into a consolidated ADLS Gen 2 data lake storage account into parquet files.  
3. It utilizes Azure Key Vault secrets that contain the storage account connection strings (connection info containing storage keys - https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#regenerate-access-keys)  
4. The example CSV files can be landed into any storage account that you have access to the storage keys.  You can land them in any location you'd like, just note the location. 
5. You can run the pipeline passing in parameters detailing the secret name, container, filename prefix, and further directory pathing if needed.  

## Asset List - These items will be created in your Azure subscription 

The PowerShell scripts will create all the items below and is driven by values with the paramfile.  You will only need to edit the paramfile03.json file.  The table below details all the components the solution will create and it's corresponding variable value in the paramfile.    

Azure Item | paramfile value | Details
| :--- | ---: | :---:
Azure Resource Group   | resourceGroupName | All the components are built within 1 resource group 
Azure Synapse Analytics workspace  | azsynapsename | Synapse Analytics workspace name
Azure Data Lake Gen 2  | azstoragename | ADLS Gen 2 for system use of Synapse workspace
Azure Data Lake Gen 2  | azstoragename2 | ADLS Gen 2 to land processed parquet files 
Azure Key Vault | akvname | Azure Key Vault to store connection string info in secret
3 Synapse Linked Services| LinkedServiceNameX | Linked Services to use in the pipeline 
Synapse datasets| DatasetNameX | Synapse Datasets to use in the pipeline
Synapse pipeline | PipelineName1 | Synapse parameter driven pipeline


## What Needs to Be Done - High Level Overview of Steps  

1. Download the files contained within [DataShare Full Sample](https://github.com/hfoley/DataSharePipeline/tree/main/DataShare%20Full%20Sample) locally to your machine.    
2. Update the paramfile03.json with the values and naming you want and save.  
3. Save CSV files in appropriate source Azure storage locations you want to use to pull data from.  Capture the text of the connection string for later use running the scripts.  
4. Run the PowerShell scripts you need.  Below are the commands you'll run using Azure CLI to build the full solution. (blog on setting up Azure CLI to run scripts https://hopefoley.com/2021/09/27/powershell-in-the-clouds/)   
	* Build all the pieces in Azure (You'll be prompted a few times for information. 1 - user and password for SQL Admin account for Synapse. 2 - text for connection string to storage account.  This will build 2 secrets you can use for the pipeline.): 
		* `./"01 - Create Resources DataShare.ps1" -filepath ./paramfile03.json` 
	* Grant rights for storage and AKV:
		* `./"02 - GrantRightsDataShareCLI.ps1" -filepath ./paramfile03.json`
	* Build the Synapse pipeline components:
		* `./"03 - Create Pipeline Parts DataShare.ps1" -filepath ./paramfile03.json`
	
5. Run the pipeline with appropriate parameter values.  

Parameter Name | paramfile value | Details
| :--- | ---: | :---:
Azure Resource Group   | resourceGroupName | All the components are built within 1 resource group 
Azure Synapse Analytics workspace  | azsynapsename | Synapse Analytics workspace name
Azure Data Lake Gen 2  | azstoragename | ADLS Gen 2 for system use of Synapse workspace
Azure Data Lake Gen 2  | azstoragename2 | ADLS Gen 2 to land processed parquet files 
Azure Key Vault | akvname | Azure Key Vault to store connection string info in secret
3 Synapse Linked Services| LinkedServiceNameX | Linked Services to use in the pipeline 
Synapse datasets| DatasetNameX | Synapse Datasets to use in the pipeline
Synapse pipeline | PipelineName1 | Synapse parameter driven pipeline

## Pre-reqs
There is a script you can use to help check for these pre-reqs and install them called 00 - PreReqCheck.ps1. Navigate to [01 Create Resources](https://github.com/hfoley/DataSharePipeline/tree/main/01%20Create%20Resources) for more details on running the script.  

1. Open that file in your preferred PowerShell IDE (administrator mode is required to install anything). 
2. PowerShell 5.1 or above needs installed locally.  You can check this by running the following script. 
		$PSVersionTable.PSVersion
2. Powershell modules needed - the latest versions I tested are listed.  00 - PreReqCheck.ps1 has syntax to install them. 
	1. Az.Resources (2.2.0) - https://docs.microsoft.com/en-us/powershell/module/az.resources
	2. Az.Storage (3.10.0) - https://docs.microsoft.com/en-us/powershell/module/az.storage
	3. Az.Synapse (0.13.0) - https://docs.microsoft.com/en-us/powershell/module/az.synapse
	4. Az.KeyVault (1.0.0) - https://docs.microsoft.com/en-us/powershell/module/az.keyvault

	
