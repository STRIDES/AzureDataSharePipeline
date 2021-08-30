# Data Share Synapse Pipeline - 01 Create Resources

The files in this location are to help build the resources we'll use in your Azure subscription.  The script will create the resources below.  It will check for the existence of the items first so you can specify existing resources in the paramfile.json.  

## File Inventory

Filename  | Details
------------- | -------------
00 - PreReqCheck.ps1  | PoSH script to help with pre-reqs
01 - Create Resources DataShare.ps1  | Posh script to create items specified in Azure
paramfile.json | Parameter file containing all details passed to PoSH scripts 

## Steps to create resources in Azure  

Step 1 - Download the files and save to a local folder. 

	 1. A numbered list
              1. A nested numbered list
              2. Which is numbered
          2. Which is numbered


	1. Download the files and save to a local folder. 
	
	2. Open the 00 - PreReqCheck.ps1 file in your preferred client to run PowerShell.  Visual Studio Code can be used for example (https://code.visualstudio.com/) or just within the PowerShell cmd window or ISE.  You can run selections within it to check and validate PowerShell version and required modules are installed.  
	<insert pic> 
	
	3. Azure Data Lake Gen 2 - will create one that's required for Synapse workspace but will leave alone 
	4. Azure Data Lake Gen 2 - will create one that we will use as our data lake and will use for our raw and processed data zones 
    5. Azure Key Vault - will create one that will be used to store connection string info in secret
	5. Synapse linked services - creates 3 linked services to use in the pipeline 
	6. Synapse dataset2 - will create 2 datasets
	7. Synapse pipeline - will create a pipeline to pull data dynamically from storage account and land in ADLS gen 2 in parquet format(#4 listed above)
