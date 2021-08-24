# Data Sharing - Synapse Analytics Solution Sample 

This solution is to help build the components of a big data architecture in Synapse Analytics to setup a method for sharing data.  This will help build all the components required within Azure to allow a method to share data contained within an Azure storage account.  GIANT SECURITY DISCLAIMER: Due to what this does, it's not the most secure way to setup an environment!!  You need to verify that you're going to be allowed to do this in your Azure environment.  You will need the connection string for the storage account to pull data from so there will need to clearance and blessings on both sides of this solution.  You may need to setup separate subscriptions/storage accounts that aren't under restrictions or policies such as HIPPA/etc.  PROCEED WITH CAUTION AND MAKE SURE YOU'VE GOTTEN APPROVAL FROM YOUR AZURE ADMINS!  
	
The architecture of the solution diagrammed below.  

![alt text](https://github.com/hfoley/EDU/blob/master/images/Hope%20Data%20Share%20Architecture.jpg?raw=true)

## Asset List - These items will be created in your Azure subscription 
	1. Azure Resource Group
	2. Azure Synapse Analytics workspace - all components will exist in the workspace
	3. Azure Data Lake Gen 2 - will create one that's required for Synapse workspace but will leave alone 
	4. Azure Data Lake Gen 2 - will create one that we will use as our data lake and will use for our raw and processed data zones 
    5. Azure Key Vault - will create one that will be used to store connection string info in secret
	5. Synapse linked services - creates 3 linked services to use in the pipeline 
	6. Synapse dataset2 - will create 2 datasets
	7. Synapse pipeline - will create a pipeline to pull data dynamically from storage account and land in ADLS gen 2 in parquet format(#4 listed above)
	
* [01 Create Resources](https://github.com/hfoley/PrecisionLearning/tree/main/01%20Create%20Resources)   - contains PowerShell scripts to build all the Azure components in the solution and grant necessary permissions. Skip this if you want to use existing resources.  
* [02 Sample Data](https://github.com/hfoley/PrecisionLearning/tree/main/02%20Sample%20Data)   - contains the raw VitalSource extract data I mimicked from documentation (link above)
 * [03 Work With Parquet Data](https://github.com/hfoley/PrecisionLearning/tree/main/03%20Work%20With%20Parquet%20Data)  - contains the SQL Server script files we'll use to create an external table and view that we'll use to pass data to Power BI.  I'll also include a Power BI template file to connect to Synapse on demand view.  

## Pre-reqs
There is a script you can use to check and install items in 01 Create Resources folder called 00 - PreReqCheck.ps1.  
1. Need to have at least PowerShell 5.1 installed.  You can check this by running the following script. 
	$PSVersionTable.PSVersion
2. Install Powershell AZ package.  This solution has been tested with 4.3.0.  You can find info on installing this at https://www.powershellgallery.com/packages/Az/
3. You may also need addtional modules if you have installed Az package some time ago.  Az.Synapse (https://www.powershellgallery.com/packages/Az.DataFactory) and Az.Synapse (https://www.powershellgallery.com/packages/Az.Synapse).  This was tested with Az.Synapse version 0.13.0
	







		

	
	


