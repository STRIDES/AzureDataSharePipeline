
<# 

This will grant storage blob contributor role for mananged service account 
created with Synapse.  It will also grant admin AAD account in the 
paramfile that right as well.  (Could be redundant...I know...but it's needed)
It will also grant rights to the Synapse MSI to get secrets from the key vault. 
#>
param(
        [Parameter(Mandatory)]
        [string]$filepath
    )


$startTime = Get-Date
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

$SubscriptionId = $filestuff.SubscriptionId
$resourceGroupName = $filestuff.resourceGroupName
$azstoragename2 = $filestuff.azstoragename2
$akvname = $filestuff.akvname
$azsynapsename = $filestuff.azsynapsename
$adminuser = $filestuff.adminuser



$startTime = Get-Date
Write-Host "The granting of access to $azstoragename2 began at " $startTime

#import-module AzureAD.Standard.Preview
AzureAD.Standard.Preview\Connect-AzureAD -Identity -TenantID $env:ACC_TID
Select-AzSubscription -SubscriptionId $SubscriptionId
#Connect-AzureAD 
$servicePrincipal = Get-AzureADServicePrincipal -Filter "DisplayName eq '$azsynapsename'"
$servicePrincipal
$ServicePrincipalId = $servicePrincipal.AppId
$ServicePrincipalId 

#Grant permissions to storage for admin user and MSI 
New-AzRoleAssignment -RoleDefinitionName "storage blob data contributor" -ApplicationId $ServicePrincipalId `
-Scope  "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$azstoragename2"

New-AzRoleAssignment -SignInName $adminuser `
    -RoleDefinitionName "storage blob data contributor" `
    -Scope  "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$azstoragename2"

#Grant permissions to AKV of get to secret created 
Set-AzKeyVaultAccessPolicy -VaultName $akvname -ServicePrincipalName $ServicePrincipalId -PermissionsToSecrets get






