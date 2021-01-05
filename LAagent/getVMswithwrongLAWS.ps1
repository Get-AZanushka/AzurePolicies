#This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
#We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code.

##Created by Anushka Madwesh (Microsoft).
## GAP - pull VMs with wrong workspace
###Param 0: Subscription ID - Subscription that holds the Resource Group/VMs to check
###Param 1: Resource Group Name - Resource Group that holds the VMs to check
###Param 2: Target Workspace ID - Workspace ID that VM monitoring data SHOULD be sent to
###Param 3: Output Text File Path - File Path to text file that will hold resource IDs of all VMs that are incorrectly monitored


$subscriptionId = $args[0]
#Connect-AzAccount -subscriptionId $subscriptionId
$rg = $args[1]
$targetWorkspace = $args[2]
$outputfile = $args[3]



$vmlist = Get-AzResource -ResourceGroupName $rg -ResourceType Microsoft.Compute/virtualMachines
$vmworkspaces = $vmlist | ForEach-Object { Get-AzVMExtension -ResourceGroupName $rg -VMName $_.Name -Name "MicrosoftMonitoringAgent" -ErrorAction SilentlyContinue}

ForEach ($vmobject in $vmworkspaces){
    if ($vmobject.PublicSettings.workspaceId -notlike $targetWorkspace){
        (Get-AzResource -ResourceGroupName $rg -ResourceType Microsoft.Compute/virtualMachines -Name $vmobject.VMName).ResourceId | Out-File -FilePath $outputfile -Append
        
    }
}