# Data Share Synapse Pipeline - 03 Sample Data

The files in this location are to help build out a sample source dataset to run through the pipeline.  These files that are stored here were downloaded from 	https://healthdata.gov/dataset/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/4cnb-m4rz.  These csv files contain hospitalization data for July and August of 2021.  

## File Inventory
You need to download and upload these files into a couple Azure storage accounts.  You should have supplied the connection string information in the running of 01 - Create Resources DataShare.ps1 where it prompts you for AKV secret.  Upload the files to any folder location within the storage accounts.  

Filename  | Details
------------- | -------------
6xf2-c3ie_2021-07-01T09-00-23.csv | July of 2021 csv
6xf2-c3ie_2021-08-01T09-00-21.csv  | August of 2021 csv (partial month data)


## Pipeline parameters
The pipeline created will have the following parameters (case sensitive).  
Pipeline parameter | Details
| :--- | :--- 
ParamSecret | name of the secret that contains the connection string for the storage account (akvsecret1/akvsecret2)
Container | root container for the path where the csv file resides
FilePrefix | text that the filename begins with
DirectoryPath | supply further directory path for file location (leave blank if in root container above)

## Steps to setup and run pipeline

1. Store the above sample files or intended csv files into the Azure storage locations 

2. Run the pipepline with parameter values appropriate (use table above for building parameters) via debug or trigger now.  Below is an example where I'll process one of the csv files contained in the storage account inside a folder called processed within the raw container (https://storageacct.blob.core.windows.net/raw/processed/6xf2-c3ie_2021-08-01T09-00-21.csv.  

<span style="display:block;text-align:center">![alt text](https://github.com/hfoley/EDU/blob/master/images/pipelineparam.jpg?raw=true)</span>

  
3. Validate the pipeline processed the raw CSV files and landed parquet files in your data lake storage refined container.  This will be within azstoragename2 ADLS Gen 2 storage account and within containername2 from your values in paramfile.json.  

4. Please provide feedback to Hope via Twitter (https://twitter.com/hope_foley) or LinkedIn (https://www.linkedin.com/in/hopefoley/).  
