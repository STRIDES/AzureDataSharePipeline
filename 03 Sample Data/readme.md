# Data Share Synapse Pipeline - 03 Sample Data

The files in this location are to help build out a sample source dataset to run through the pipeline.  These files that are stored here were downloaded from 	https://healthdata.gov/dataset/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/4cnb-m4rz.  These csv files contain hospitalization data for July and August of 2021.  

## File Inventory
You need to download and store these files in an Azure storage account 

Filename  | Details
------------- | -------------
6xf2-c3ie_2021-07-01T09-00-23.csv | July of 2021 csv
6xf2-c3ie_2021-08-01T09-00-21.csv  | August of 2021 csv (partial month data)

You will need to upload the files above into storage locations that you can obtain the connection string information.  

## Pipeline parameters
Pipeline parameter | Details
| :--- | :--- 
tbd | bla
tbd | bla 

## Steps to setup and run pipeline

1. Store the above sample files or intended csv files into the Azure storage locations 

2. Run the pipepline with parameter values appropriate (use table above for building parameters)
  
3. Validate the pipeline processed the raw CSV files and landed parquet files in your data lake storage refined container.  

4. Please provide feedback to Hope via Twitter (https://twitter.com/hope_foley) or LinkedIn (https://www.linkedin.com/in/hopefoley/).  
