<# This file is driven by parameter file passed.  
There is a sample starting one in the github repo called paramfile.json 
You'll need to update that file and pass when running this script. 
Put all the files in the same folder as the paramfile.  

Tips: Storage requires lowercase only in naming 
Tips: Synapse SQL Pools have to be 15 or less characters 
Tips: prefix should be small 3-5 characters to not cause issues with rules for storage for example

You can run this script by sample syntax below: 
& "C:\PSScripts\03 - Create Pipeline Parts.ps1" -filepath "C:\PSScripts\paramfile.json"

 #>

 param(
    [Parameter(Mandatory)]
    [string]$filepath
)

$startTime = Get-Date
$folderpath = Split-Path -Path $filepath
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

#Pull out the contents of the parameter file
$SubscriptionId = $filestuff.SubscriptionId
$azstoragename2 = $filestuff.azstoragename2
$akvname = $filestuff.akvname
#$containername1 = $filestuff.containername1

#variables for Synapse workspace. Based on prefix from param file
$azsynapsename = $filestuff.azsynapsename

#linked service to data lake 
$LinkedServiceName1 = $filestuff.LinkedServiceName1 
$linkedsvcfile1 = $filestuff.linkedsvcfile1
$linkedSvcfullpath = $folderpath + $linkedsvcfile1
$linkedsvcurl = "https://"+$azstoragename2+".dfs.core.windows.net"
Write-Host $linkedSvcfullpath 

#linked service to AKV 
$LinkedServiceName2 = $filestuff.LinkedServiceName2 
$linkedsvcfile2 = $filestuff.linkedsvcfile2
$linkedSvcfullpath2 = $folderpath + $linkedsvcfile2
$baseUrl = "https://"+$akvname+".vault.azure.net"
Write-Host $linkedSvcfullpath2 

#linked service to external storage using AKV secret
$LinkedServiceName3 = $filestuff.LinkedServiceName3 
$linkedsvcfile3 = $filestuff.linkedsvcfile3
$linkedSvcfullpath3 = $folderpath + $linkedsvcfile3
$baseUrl = "https://"+$akvname+".vault.azure.net"
Write-Host $linkedSvcfullpath3 

#The parquet files to load into Synapse for the load processes 
$DatasetName1 = $filestuff.DatasetName1
$DatasetFile1 = $filestuff.DatasetFile1
$DataSet1fullpath = $folderpath + $DatasetFile1
Write-Host $DataSet1fullpath

#Azure SQL metadata table driving the load process ADF.MetadataLoad
$DatasetName2 = $filestuff.DatasetName2
$DatasetFile2 = $filestuff.DatasetFile2
$DataSet2fullpath = $folderpath + $DatasetFile2
Write-Host $DataSet2fullpath

#Pipeline 
$PipelineName1 = $filestuff.PipelineName1
$PipelineFile1 = $filestuff.PipelineFile1
$PL1fullpath = $folderpath + $PipelineFile1 
Write-Host $PL1fullpath
<#####################variables below do not need updated #> 

Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId
Write-Host "The Synapse pipeline parts creation script was started " $startTime
Write-Host "The Synapse workspace is " $azsynapsename
Set-Location $folderpath

<#Updating json files to build pipelines from parameters file #>
#Editing data lake linked service json file
$linkedsvcedit = (get-content $linkedSvcfullpath -raw | ConvertFrom-Json)
$linkedsvcedit.name = $LinkedServiceName1
$linkedsvcedit.properties.typeProperties.url = $linkedsvcurl
$linkedsvcedit | ConvertTo-Json -depth 32| set-content $linkedSvcfullpath

#Editing AKV linked service json file
$linkedsvcedit2 = (get-content $linkedSvcfullpath2 -raw | ConvertFrom-Json)
$linkedsvcedit2.name = $LinkedServiceName2
$linkedsvcedit2.properties.typeProperties.baseUrl = $baseUrl
$linkedsvcedit2 | ConvertTo-Json -depth 32| set-content $linkedSvcfullpath2

#Editing data lake linked service json file
$linkedsvcedit3 = (get-content $linkedSvcfullpath3 -raw | ConvertFrom-Json)
$linkedsvcedit3.name = $LinkedServiceName3
$linkedsvcedit3.properties.typeProperties.connectionString.store.referenceName = $LinkedServiceName2
$linkedsvcedit3 | ConvertTo-Json -depth 32| set-content $linkedSvcfullpath3

#Editing DynamicCustStorageSrc data set
$editsrcds = (get-content $DataSet1fullpath -raw | ConvertFrom-Json)
$editsrcds.name = $filestuff.DatasetName1
$editsrcds.properties.linkedServiceName.referenceName = $LinkedServiceName3
$editsrcds | ConvertTo-Json -depth 32| set-content $DataSet1fullpath

$editsinkds = (get-content $DataSet2fullpath -raw | ConvertFrom-Json)
$editsinkds.name = $filestuff.DatasetName2
$editsinkds.properties.linkedServiceName.referenceName = $filestuff.LinkedServiceName1
$editsinkds.properties.typeProperties.location.fileSystem = $filestuff.containername2
$editsinkds | ConvertTo-Json -depth 32| set-content $DataSet2fullpath

#Editing pipeline CustomerDataPullPL.json file 
$editpl = (get-content $PL1fullpath -raw | ConvertFrom-Json)
$editpl.name = $filestuff.PipelineName1
$editpl.properties.activities[0].inputs[0].referenceName = $filestuff.DatasetName1
$editpl.properties.activities[0].outputs[0].referenceName = $filestuff.DatasetName2
$editpl | ConvertTo-Json -depth 100| set-content $PL1fullpath

#>
#################

$LinkedServiceCheck = Get-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName1 -ErrorAction SilentlyContinue
if(-not $LinkedServiceCheck)
    {
    Write-Host "Linked Service '$LinkedServiceName1' doesn't exist and will be created"
    Set-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName1  -DefinitionFile $linkedSvcfullpath
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName1' already created"}
$endTime = Get-Date
write-host "Ended Linked Service creation at " $endTime

$LinkedServiceCheck2 = Get-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName2 -ErrorAction SilentlyContinue
if(-not $LinkedServiceCheck2)
    {
    Write-Host "Linked Service '$LinkedServiceName2' doesn't exist and will be created"
    Set-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName2  -DefinitionFile $linkedSvcfullpath2
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName2' already created"}
$endTime = Get-Date
write-host "Ended Linked Service creation at " $endTime

$LinkedServiceCheck3 = Get-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName3 #-ErrorAction SilentlyContinue
if(-not $LinkedServiceCheck3)
    {
    Write-Host "Linked Service '$LinkedServiceName3' doesn't exist and will be created"
    Set-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedServiceName3  -DefinitionFile $linkedSvcfullpath3
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName3' already created"}
$endTime = Get-Date
write-host "Ended Linked Service creation at " $endTime


$Dataset1Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName1 -ErrorAction SilentlyContinue
if(-not $Dataset1Check)
    {
    Write-Host "Dataset '$DatasetName1' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName1 -DefinitionFile $DataSet1fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName1' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName1' creation at " $endTime


$Dataset2Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName2 -ErrorAction SilentlyContinue
if(-not $Dataset2Check)
    {
    Write-Host "Dataset '$DatasetName2' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName2 -DefinitionFile $DataSet2fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName2' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName2' creation at " $endTime

#Create the pipeline if doesn't exist
$Pipeline1Check = Get-AzSynapsePipeline -Name $PipelineName1 -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
if(-not $Pipeline1Check)
    {
    Write-Host "Pipeline '$PipelineName1' doesn't exist and will be created"
    Set-AzSynapsePipeline -WorkspaceName $azsynapsename -Name $PipelineName1 -DefinitionFile $PL1fullpath
    }
else 
    {Write-Host "Pipeline '$PipelineName1' already created"}

write-host "Pipeline components completed at " $endTime