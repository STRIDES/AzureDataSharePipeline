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

1. Download all the files contained in this folder and save to a local folder location.  

2. Open the 00 - PreReqCheck.ps1 file in your preferred client to run PowerShell.  Visual Studio Code can be used for example (https://code.visualstudio.com/) or the PowerShell ISE.  You can step through and run selections of the code to check and validate PowerShell version and required modules are installed.
  
![alt text](https://github.com/hfoley/EDU/blob/master/images/Hope%20Precision%20Learning2.jpg?raw=true)

3. Open and update all the values needed within the paramfile.json.  Anything that contains <> requires your input.  Replace all the values including the <> within the " ".  
	
4.  
