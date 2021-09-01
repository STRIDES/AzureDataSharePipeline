<# This file is driven by parameter file passed.  
There is a sample starting one in the github repo called paramfile.json 
You'll need to update that file and pass as the variable when running this script. 
Put all the files used in this automation in the same folder as the paramfile.  

Tips: Storage accounts require lowercase only in naming 
Tips: Synapse SQL Pools have to be 15 or less characters 


You can run this script by sample syntax below: 
& "C:\PSScripts\01 - CreateDataShareResources.ps1" -filepath "C:\PSScripts\paramfile.json"

 #>

param(
        [Parameter(Mandatory)]
        [string]$filepath
    )

$startTime = Get-Date
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

$SubscriptionId = $filestuff.SubscriptionId
$resourceGroupName = $filestuff.resourceGroupName
$resourceGroupLocation = $filestuff.resourceGroupLocation 

#Synapse variables 
$azsynapsename = $filestuff.azsynapsename
$azstoragename = $filestuff.azstoragename
$containersys = $filestuff.containersys
$SKUName = $filestuff.SKUName 
$storagekind = $filestuff.storagekind 
#$ManagedVirtualNetwork = $filestuff.ManagedVirtualNetwork 
#$adminuser = $filestuff.adminuser 
$tenantid = $filestuff.tenantid

#Firewall to connect to Synapse workspace 
$firewallrulename = $filestuff.firewallrulename  


#ADLS 2 - this will be the ADLS landing area for parquet files
$azstoragename2 = $filestuff.azstoragename2 
$containername1 = $filestuff.containername1
$containername2 = $filestuff.containername2

#Azure Key Vault 
$akvname = $filestuff.akvname 
$akvsecret1 = $filestuff.akvsecret1
$akvsecret2 = $filestuff.akvsecret2
#$akvsecret3 = $filestuff.akvsecret3
#####################variables below do not need updated

Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId
Write-Host "The resource group creation script was started " $startTime
$RGCheck = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(-not $RGCheck)
    {
    Write-Host "Resource group '$resourceGroupName' doesn't exist and will be created"
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    }
else 
    {Write-Host "Resource group '$resourceGroupName' already created"}
$endTime = Get-Date
write-host "Ended resource group creation at " $endTime


$startTime = Get-Date

Write-Host "The Azure ADLS Gen 2 Sys Storage creation script was started " $startTime

$ADLSCheck = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $azstoragename -ErrorAction SilentlyContinue
if(-not $ADLSCheck)
    {
    Write-Host "The ADLS storage '$azstoragename' doesn't exist and will be created"
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $azstoragename -Location $resourceGroupLocation -SkuName $SKUName -Kind $storagekind  -EnableHierarchicalNamespace $true
     $ctx = New-AzStorageContext -StorageAccountName $azstoragename -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containersys -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containersys' doesn't exist and will be created"
            New-AzStorageContainer -Name $containersys -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containersys' already there"
            }
    }
else 
    {
    Write-Host "The ADLS storage '$azstoragename' already created"
        $ctx = New-AzStorageContext -StorageAccountName $azstoragename -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containersys -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containersys' doesn't exist and will be created"
            New-AzStorageContainer -Name $containersys -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containersys' already there"
            }
    }


<# Main secondary ADLS to use for data and containers used. #>
$ADLSCheck2 = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $azstoragename2 -ErrorAction SilentlyContinue
if(-not $ADLSCheck2)
    {
    Write-Host "The ADLS storage '$azstoragename2' doesn't exist and will be created"
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $azstoragename2 -Location $resourceGroupLocation -SkuName $SKUName -Kind $storagekind  -EnableHierarchicalNamespace $true 
     $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containername1 -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containername1' doesn't exist and will be created"
            New-AzStorageContainer -Name $containername1 -Context $ctx
            New-AzStorageContainer -Name $containername2 -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containername1' already there"
            }
    }
else 
    {
    Write-Host "The ADLS storage '$azstoragename2' already created"
        $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containername1 -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containername1' doesn't exist and will be created"
            New-AzStorageContainer -Name $containername1 -Context $ctx
            New-AzStorageContainer -Name $containername2 -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containername1' already there"
            }
    }

Write-Host "The Azure Synapse Workspace script was started " $startTime

$SynapseCheck =  Get-AzSynapseWorkspace -ResourceGroupName $ResourceGroupName -Name $azsynapsename -ErrorAction SilentlyContinue
if(-not $SynapseCheck)
    {
    Write-Host "Synapse workspace '$azsynapsename' doesn't exist and will be created"
    $config = New-AzSynapseManagedVirtualNetworkConfig -AllowedAadTenantIdsForLinking $tenantid
    New-AzSynapseWorkspace -ResourceGroupName $resourceGroupName -Name $azsynapsename -Location $resourceGroupLocation -DefaultDataLakeStorageAccountName $azstoragename -DefaultDataLakeStorageFilesystem $containersys -SqlAdministratorLoginCredential (Get-Credential -Message "SQL Admin") -ManagedVirtualNetwork $config
    }
else 
    {Write-Host "Synapse workspace '$azsynapsename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse workspace creation script at " $endTime

$startTime = Get-Date
$clientip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip

$firewallrule = Get-AzSynapseFirewallRule -ResourceGroupName $resourceGroupName -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
if(-not $firewallrule)
    {
    Write-Host "Synapse workspace firewall '$firewallrulename' doesn't exist and will be created"
    New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -Name $firewallrulename -StartIpAddress $clientip -EndIpAddress $clientip 
    }
else 
    {Write-Host "Synapse workspace firewall '$firewallrulename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse firewall rule creation script at " $endTime

$startTime = Get-Date

Write-Host "The Azure Key Vault script was started " $startTime

$AKVCheck = Get-AzKeyVault -VaultName $akvname -ErrorAction SilentlyContinue
if(-not $AKVCheck)
    {
    Write-Host "Azure Key Vault '$akvname' doesn't exist and will be created"
    New-AzKeyVault -VaultName $akvname -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation
    }
else 
    {Write-Host "Azure Key Vault '$akvname' already created"}

$endTime = Get-Date
write-host "Ended Azure Key Vault creation script at " $endTime


$startTime = Get-Date

Write-Host "The Azure Key Vault secret 1 creation was started " $startTime

$SecretCheck1 = Get-AzKeyVaultSecret -VaultName $akvname -Name $akvsecret1 -ErrorAction SilentlyContinue
if(-not $SecretCheck1)
    {
    Write-Host "Azure Key Vault secret '$akvsecret1' doesn't exist and will be created"
    $Secret1 = Read-Host -Prompt "Enter text for AKV secret '$akvsecret1'" -AsSecureString
    Set-AzKeyVaultSecret -VaultName $akvname -Name $akvsecret1 -SecretValue $Secret1
    }
else 
    {Write-Host "Azure Key Vault '$akvsecret1' already created"}

$endTime = Get-Date

Write-Host "The Azure Key Vault secret 2 creation was started " $startTime

$SecretCheck2 = Get-AzKeyVaultSecret -VaultName $akvname -Name $akvsecret2 -ErrorAction SilentlyContinue
if(-not $SecretCheck2)
    {
    Write-Host "Azure Key Vault secret '$akvsecret2' doesn't exist and will be created"
   $Secret2 = Read-Host -Prompt "Enter text for AKV secret '$akvsecret2'" -AsSecureString
    Set-AzKeyVaultSecret -VaultName $akvname -Name $akvsecret2 -SecretValue $Secret2
    }
else 
    {Write-Host "Azure Key Vault '$akvsecret2' already created"}


$endTime = Get-Date

write-host "Ended Azure Key Vault creation script at " $endTime
write-host "Total resources creation script finish at " $endTime

