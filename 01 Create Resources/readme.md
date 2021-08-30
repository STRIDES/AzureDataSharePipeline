# Data Share Synapse Pipeline - 01 Create Resources

The files in this location are to help build the resources we'll use in your Azure subscription.  The script will create the resources below.  It will check for the existence of the items first so you can specify in the paramfile.json existing items.    

Filename  | Details
------------- | -------------
00 - PreReqCheck.ps1  | PoSH script to help with pre-reqs
01 - Create Resources DataShare.ps1  | Posh script to create items specified in Azure
paramfile.json | Parameter file containing all details passed to PoSH scripts 


## Steps we'll  
	1. Azure Resource Group
	2. Azure Synapse Analytics workspace - all components will exist in the workspace
	3. Azure Data Lake Gen 2 - will create one that's required for Synapse workspace but will leave alone 
	4. Azure Data Lake Gen 2 - will create one that we will use as our data lake and will use for our raw and processed data zones 
    5. Azure Key Vault - will create one that will be used to store connection string info in secret
	5. Synapse linked services - creates 3 linked services to use in the pipeline 
	6. Synapse dataset2 - will create 2 datasets
	7. Synapse pipeline - will create a pipeline to pull data dynamically from storage account and land in ADLS gen 2 in parquet format(#4 listed above)
