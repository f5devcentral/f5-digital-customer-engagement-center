using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Initialize Conf Files
$app1VmssConf = New-TemporaryFile
$app1WestVmssConf = New-TemporaryFile
$app1EastVmssConf = New-TemporaryFile

############################ Functions ############################

# Function GetVmssIps: Retrieve VM IP addresses from VMSS
function GetVmssIps {
  param ($vmssName, $rgName)
  $VMs = Get-AzVmssVM -ResourceGroupName $rgName -VMScaleSetName $vmssName
  $nicName = ($VMs[0].NetworkProfile.NetworkInterfaces[0].Id).Split('/')[-1]
  foreach ($vm in $VMs)
  {
    $resourceName = $vmssName + "/" + $vm.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30
    $ip = $target.Properties.ipConfigurations[0].properties.privateIPAddress
    # Output IP address for return
    $ip
  }
}

############################ Main ############################

# Get VM IP addresses in VMSS App West
Write-Host "Retrieving VMSS IP addresses for App West"
$resultAppWest = GetVmssIps -vmssName "${vmssAppWest}" -rgName "${rgWest}"
foreach ($ip in $resultAppWest)
{
  # add to app west upstream conf
  $server = "server " + $ip + ":80;" | Out-File $app1WestVmssConf -Append
  # add to main app1 upstream conf too
  $server = "server " + $ip + ":80;" | Out-File $app1VmssConf -Append
}

# Get VM IP addresses in VMSS App East
Write-Host "Retrieving VMSS IP addresses for App East"
$resultAppEast = GetVmssIps -vmssName "${vmssAppEast}" -rgName "${rgEast}"
foreach ($ip in $resultAppEast)
{
  # add to app east upstream conf
  $server = "server " + $ip + ":80;" | Out-File $app1EastVmssConf -Append
  # add to main app1 upstream conf too as backup member
  $server = "server " + $ip + ":80 backup;" | Out-File $app1VmssConf -Append
}

# Validate file contents
Write-Host "Validating contents"
cat $app1VmssConf
cat $app1WestVmssConf
cat $app1EastVmssConf

############################ Git ############################

# TBD

############################ HTTP Response ############################

# Output HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = "Azure Function Completed Successfully. Check GitHub actions!"
})
