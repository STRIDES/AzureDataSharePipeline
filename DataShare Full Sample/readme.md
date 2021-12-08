# DataShare Full Sample
This folder contains the files you'll need to create all the components for the solution including a sample set of data.  The only file you need to update is the paramfile03.json.  All the scripts use this file to drive the names, locations, ect. to build it out in your environment.  Make sure you have rights to create resources in your Azure subscription.  You can use existing resources for this solution.  The script will check for it's existence first, before creating it.  

## File List - These items will be created in your Azure subscription

Filename  | Description
------------- | -------------
paramfile03.json | **Only file to update** Parameter file that all PowerShell scripts use
00 - PreReqCheck.ps1 | Script that can be used to check for modules needed
01 - Create Resources DataShare.ps1  | Creates all the items in Azure subscription
02 - GrantRightsDataShareCLI.ps1 | Will grant rights to MSI and setup get secret permissions for Azure Key Vault using Azure CLI
02 - GrantRightsDataShare.ps1 | Will grant rights to MSI and setup get secret permissions for Azure Key Vault using local machine PowerShell
03 - Create Pipeline Parts DataShare.ps1 | Will create the pipelines and related items in Synapse workspace
DataLakeLS | Json file for creation of the linked server pointing to ADLS Gen 2 (azstorage2 in paramfile01.json)
AKVLS.json | Json file tied to the creation of the linked server pointing to Azure Key Vault
CustomerStorageLS.json | Json file tied to creation of dynamic linked server to connect to storage accounts with details in AKV
DataLakeLS.json | Json file tied to creation of dataset to pull metadata for tables to load
DynamicStorageSrcDS | Json file tied to creation of dataset to point to CSV location in storage account
DataLakeSinkDS.json | Json file tied to creation of dataset to land the parquet files built from source CSV data
DynamicDataPullPL | Json file tied to creation of pipeline with copy task to pull data from CSVs in Azure storage and land in parquet in data lake

## Azure Asset List - These items will be created in your Azure subscription
1. Azure Resource Group
2. Azure Key Vault - key vault will be used to store storage credentials  
3. 2 - Azure Data Lake Gen 2 accounts - one account for system use with Synapse, one for data lake and location to land extracted parquet files 
4. Azure Synapse Workspace - workspace where pipelines will be created
5. Azure Synapse - Dynamic Data Pull pipeline - parameter driven pipeline to pull CSVs from and land into ADLS Gen 2 lake storage account


## Steps 
1. Download all the files locally or to storage account fileshare used for CLI (see https://hopefoley.com/2021/09/27/powershell-in-the-clouds/ for help setting up).  Keep all the files in one folder location.   
1. Update the paramfile03.json with the values you want to use for the rest of the scripts.  Storage is finicky in the rules it has for naming.  Keep storage params lowercase and under 15 characters.  You will need to replace any values containing <text>.  Anything without <> surrounding it is optional to change.  
2. Save CSV files in appropriate source Azure storage locations you want to use to pull data from. Capture the text of the connection string for later use running the scripts.
3. Run the 01 - Create Resources DataShare.ps1 script and supply the param file location.  You'll be prompted for your login credentials to Azure.  You'll also be prompted for a username and password.  This will become your Synapse workspace SQL admin login and password.  You will also be prompted to supply the text to be contained in 2 secrets.  You will need to paste in the connection string info for the storage account(s) you want to pull CSVs from.  Below is some sample syntax to run the file and pass the paramfile within Azure CLI and locally.  Keep all your scripts, paramfile03.json and all json files in the same folder location.  
  Azure CLI:  `./"01 - Create Resources DataShare.ps1" -filepath ./paramfile03.json`<br>
  Locally:  `& "C:\folder\01 - Create Resources DataShare.ps1" -filepath "C:\folder\paramfile03.json"`
4. Run the 02 - GrantRightsDataShare.ps1 script.  You'll again be prompted for login to Azure.  This script will assign the rights needed to the ADLS storage account.  It will grant your account (or the admin user provided in the paramfile) to the role Storage Blob Data Contributor role on the ADLS account.  Below is a sample syntax.  
  Azure CLI:  `./"02 - GrantRightsDataShare.ps1" -filepath ./paramfile03.json`<br>
  Locally:  `& "C:\folder\02 - GrantRightsDataShare.ps1" -filepath "C:\folder\paramfile03.json"`
5. Run the 03 - CreateSynLoadPipelineParts.ps1 script.  You'll again be prompted for login to Azure.  This script will create the items within the Synapse workspace to build the pipelines.  It will create linked services, datasets, and pipelines.  Below is a sample syntax.  
  Azure CLI:  `./"03 - Create Pipeline Parts DataShare.ps1" -filepath ./paramfile03.json`<br>
  Locally:  `& "C:\folder\03 - Create Pipeline Parts DataShare.ps1" -filepath "C:\folder\paramfile03.json"`
6. Navigate to the Synapse workspace and open up Synapse Studio.  Navigate to the integrate pane (far left pipe icon).  You can now run the DataShare pipeline.  You will be prompted again for the filename that will match to our [ADF].[MetadataLoad] for where it will load the data in the dedicated SQL pool.  This pattern will truncate and reload the destination table.  Verify it loads successfully (can use script DemoWatchSynapseLoadTables.sql). 
14.  You can also now run the Incremental Load pipeline.  This will use a staging table to load what's contained in the parquet file.  It will then trunate the staging table, check for values in the final target table that match, delete them, and reload from the staging table.  
15.  Validate you have values within your [COW].[Biometrics_Stg] and [COW].[Biometrics] tables.  You can add another entry into the [ADF].[MetadataLoad] for the other extracted parquet file and re-run the pipeline passing that filename into the parameter.  
16. If running the SQL Not Date Based Extract, validate the logging is captured in ADF.PipelineLog table. Note: not all fields populate (update later to come to resolve)
