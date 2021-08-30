#Need at least 5.1 of PowerShell running
#Also will need to run in administrator mode if we need to install modules.
$PSVersionTable.PSVersion


#Check for version of Az Powershell modules needed for  
#Try both as sometimes I will get nothing on the first cmd
    $modules = ("Az.Resources","Az.Storage","Az.Synapse","Az.KeyVault")

    foreach ($module in $modules)
        {if (Get-Module -ListAvailable -Name $module) 
            {Write-Host $module "module exists"
            } 
        else 
            {
                Write-Host $module "Module does not exist"
            }
        } 

#You can check the version of the modules using 
$modules = ("Az.Resources","Az.Storage","Az.Synapse","Az.KeyVault")

foreach ($module in $modules)
        {Get-Module -Name $module -ListAvailable | Select-Object name, version
        } 

<#The code has been tested with the following versions 
Name         Version
----         -------
Az.Resources 2.2.0  
Az.Storage   3.10.0 
Az.Synapse   0.13.0 
Az.KeyVault  1.0.0  
#> 

#If you need to install a module above you can do so via the commands below 
Install-Module -Name Az.Synapse -RequiredVersion 0.13.0 

#Sometimes I have had to install over a dependancy and can be done with the code below
Install-Module -Name Az.Synapse -RequiredVersion 0.13.0 -allowclobber

#can use command below to see the modules that are installed with Az 
#tested with 
Get-Module -Name Az* -ListAvailable

#we'll use Az.Synapse heavily 
#you can check for that specific one by running code below 
#Testing as of 8/18/21 with version 0.13.0 (latest available is 0.14.0)
Get-Module -Name Az.Sy* -ListAvailable

# You can connect to Azure and pull details in PowerShell
# This below will connect to Azure and pull subscription and tenant ids.  
# it will open in a grid view
Connect-AzAccount
Get-AzSubscription | select Name, Id, TenantId | Out-GridView



#You'll need SQL and Synapse providers enabled in your subscription 
#Below is a way you can add them via Powershell
#or can do via portal https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/error-register-resource-provider
Get-AzResourceProvider -ListAvailable
Get-AzResourceProvider -ProviderNamespace Microsoft.SQL
Get-AzResourceProvider -ProviderNamespace Microsoft.Synapse
