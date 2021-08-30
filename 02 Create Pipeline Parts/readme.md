# Data Share Synapse Pipeline - 02 Create Pipeline Parts

The files in this location are to help build the resources within the Synapse workspace needed for the pipeline.  The script will create the resources below.  It will check for the existence of the items first so you can specify existing resources in the paramfile.json.  You will also need to have the corresponding json files stored locally that drive the creation of the pieces in the Synapse workspace.  

## File Inventory

Filename  | Details
------------- | -------------
03 - Create Pipeline Parts.ps1  | PoSH script to edit the json files with parameters specified and create components in Synapse workspace
paramfile.json | Parameter file containing all details passed to PoSH scripts (skip if you already did this in 01 Create Resources)
AKVLS.json | Azure Key Vault linked service json file (linkedsvcfile2 in paramfile)
CustomerStorageLS.json | Source storage account linked service json file (linkedsvcfile3 in paramfile)
DataLakeLS.json | Destination data lake linked service json file (linkedsvcfile1 in paramfile) 
DataLakeSinkDS.json | Dataset to land parquet files in data lake json file (DatasetFile2 in paramfile)
DynamicStorageSrcDS.json | Dynamic source dataset to pull CSV files from (DatasetFile1 in paramfile)  
DynamicDataPullPL.json | Pipeline creation json file (PipelineFile1 in paramfile) 


## Steps to create resources in Azure  

Step 1 - Download the files and save to a local folder if you haven't already. 

1. Download all the files contained in this folder and save to a local folder location.  

2. Skip this step if you did already in 01 Create Resources section.  Open the 00 - PreReqCheck.ps1 file in your preferred client to run PowerShell.  Visual Studio Code can be used for example (https://code.visualstudio.com/) or the PowerShell ISE.  You can step through and run selections of the code to check and validate PowerShell version and required modules are installed.
  
![alt text](https://github.com/hfoley/EDU/blob/master/images/VSCodeRunSelection.jpg?raw=true)

3. Skip this step if you did already in 01 Create Resources section.  Open and update all the values needed within the paramfile.json.  Anything that contains <> requires your input.  Replace all the values including the <> within the " ".  
	![alt text](https://github.com/hfoley/EDU/blob/master/images/EditingParamFile.jpg?raw=true)
  
4.  Run the PowerShell script 03 - Create Pipeline Parts.ps1 by running the following command in the PowerShell client of choice

	`& "C:\localfolder\03 - Create Pipeline Parts.ps1" -filepath "C:\localfolder\paramfile.json`

5.  Verify all the components created within Synapse workspace. 

Continue on to [03 Sample Data](https://github.com/hfoley/DataSharePipeline/tree/main/03%20Sample%20Data) to find details on running the pipeline and a sample dataset to test.  



