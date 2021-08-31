# Data Sharing - Synapse Analytics Pipeline Solution Pattern 

This solution is to help build out a process to collect data contained in an Azure storage account, internal or external.  These PowerShell scripts will build out all the the components of this architecture using a Synapse Analytics workspace, Azure Data Lake storage, and an Azure Key Vault.  It will also build out the parameter driven pipelines to automate the sharing of the data (example uses CSVs) across environments.  **GIANT SECURITY DISCLAIMER**: Due to what this does, it's not the most secure way to setup an environment!!  You need to verify that you're going to be allowed to do this in your Azure environment and potentially plan the location based on policies/etc.  You will need the connection string for the storage account to pull data from so there will need to clearance and blessings on both sides of this solution.  You may need to setup separate subscriptions/storage accounts that aren't under restrictions or policies such as HIPPA/etc.  **PROCEED WITH CAUTION AND MAKE SURE YOU'VE GOTTEN APPROVAL FROM YOUR AZURE ADMINS AND DATA GOVERNANCE ENTITIES!**  
	

## What We'll Do - High Level Overview of Steps  

1. Download the files you'll need locally into one folder and note the folder location.  This code assumes all files are in one folder location without subfolders.   
2. Update the paramfile.json with the values and naming you want and save.  
3. Run the PowerShell scripts you need.  If you need to build out the items in Azure, you'll run: 
	& "C:\localfolder\01 - BaseInstall.ps1" -filepath "C:\localfolder\paramfile.json"!
4. Save CSV files in appropriate source locations you want to use to pull data from.  
5. Run the pipeline with appropriate parameter values.  

## Asset List - These items will be created in your Azure subscription 

The PowerShell scripts will create all the items below and is driven by values with the paramfile.  You will only need to edit the paramfile.json file.  The table below details all the components the solution will create and it's corresponding variable value in the paramfile.    

Azure Item | paramfile value | Details
| :--- | ---: | :---:
Azure Resource Group   | resourceGroupName | All the components are built within 1 resource group 
Azure Synapse Analytics workspace  | azsynapsename | Synapse Analytics workspace name
Azure Data Lake Gen 2  | azstoragename | ADLS Gen 2 for system use of Synapse workspace
Azure Data Lake Gen 2  | azstoragename2 | ADLS Gen 2 to land processed parquet files 
Azure Key Vault | akvname | Azure Key Vault to store connection string info in secret
Synapse Linked Services| LinkedServiceNameX | Linked Services to use in the pipeline 
Synapse datasets| DatasetNameX | Synapse Datasets to use in the pipeline
Synapse pipeline | PipelineName1 | Synapse parameter driven pipeline



The architecture of the solution diagrammed below.  


![alt text](https://github.com/hfoley/EDU/blob/master/images/Hope%20Data%20Share%20Architecture.jpg?raw=true)

	
Navigate to each section to view the scripts needed and for further details.  
* [01 Create Resources](https://github.com/hfoley/DataSharePipeline/tree/main/01%20Create%20Resources)   - contains PowerShell scripts to build all the Azure components in the solution and grant necessary permissions. Skip this if you want to use existing resources.  
* [02 Create Pipeline Parts](https://github.com/hfoley/DataSharePipeline/tree/main/02%20Create%20Pipeline%20Parts) - contains the PowerShell script 02 - Create Pipeline Parts.ps1 and correlated json files to build out the items needed for the pipeline to pull and process the csv files.
* [03 Sample Data](https://github.com/hfoley/DataSharePipeline/tree/main/03%20Sample%20Data) - contains a few example raw csv files extracted that detail hospitalization metrics from the site https://healthdata.gov/dataset/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/4cnb-m4rz   

## Pre-reqs
There is a script you can use to help check for these pre-reqs and install them in 01 Create Resources folder called 00 - PreReqCheck.ps1. Navigate to [01 Create Resources](https://github.com/hfoley/DataSharePipeline/tree/main/01%20Create%20Resources) for more details on running the script.  

1. Open that file in your preferred PowerShell IDE (administrator mode is required to install anything). 
2. PowerShell 5.1 or above needs installed locally.  You can check this by running the following script. 
		$PSVersionTable.PSVersion
2. Powershell modules needed - the latest versions I tested are listed.  00 - PreReqCheck.ps1 has syntax to install them. 
	1. Az.Resources (2.2.0) - https://docs.microsoft.com/en-us/powershell/module/az.resources
	2. Az.Storage (3.10.0) - https://docs.microsoft.com/en-us/powershell/module/az.storage
	3. Az.Synapse (0.13.0) - https://docs.microsoft.com/en-us/powershell/module/az.synapse
	4. Az.KeyVault (1.0.0) - https://docs.microsoft.com/en-us/powershell/module/az.keyvault

	
