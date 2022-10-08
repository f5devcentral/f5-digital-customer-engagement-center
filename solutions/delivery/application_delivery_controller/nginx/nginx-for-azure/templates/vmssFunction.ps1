############################ Powershell ############################

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Retrieve VM IP addresses in App West VMSS
$vmssName = "${vmssNameWest}"
$rgName = "${rgNameWest}"
$VMs = Get-AzVmssVM -ResourceGroupName $rgName -VMScaleSetName $vmssName
$nicName = ($VMs[0].NetworkProfile.NetworkInterfaces[0].Id).Split('/')[-1]
$count = $VMs.Length
$resultAppWest = foreach ($vm in $VMs)
{
    $resourceName = $vmssName + "/" + $VM.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30
    if ($VMs.Length -eq 1) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;"
    }
    elseif ($count -eq 1) {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;"
    }
    elseif ($count -eq $VMs.Length) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n"
        $count = $count - 1
    }
    else {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n"
        $count = $count - 1
    }
}

# Retrieve VM IP addresses in App East VMSS for 'backup'
$vmssName = "${vmssNameEast}"
$rgName = "${rgNameEast}"
$VMs = Get-AzVmssVM -ResourceGroupName $rgName -VMScaleSetName $vmssName
$nicName = ($VMs[0].NetworkProfile.NetworkInterfaces[0].Id).Split('/')[-1]
$count = $VMs.Length
$resultAppEastBackup = foreach ($vm in $VMs)
{
    $resourceName = $vmssName + "/" + $VM.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30
    if ($VMs.Length -eq 1) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;"
    }
    elseif ($count -eq 1) {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;"
    }
    elseif ($count -eq $VMs.Length) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;`r`n"
        $count = $count - 1
    }
    else {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;`r`n"
        $count = $count - 1
    }
}

# Retrieve VM IP addresses in App East VMSS
$count = $VMs.Length
$resultAppEast = foreach ($vm in $VMs)
{
    $resourceName = $vmssName + "/" + $VM.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30
    if ($VMs.Length -eq 1) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;"
    }
    elseif ($count -eq 1) {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;"
    }
    elseif ($count -eq $VMs.Length) {
        "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n"
        $count = $count - 1
    }
    else {
        "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n"
        $count = $count - 1
    }
}

############################ nginx.conf ############################

$nginxConfig = @"
http {

  upstream app1 {
$resultAppWest
$resultAppEastBackup
  }
  upstream app1-west {
$resultAppWest
  }
  upstream app1-east {
$resultAppEast
  }

  server {
    listen 80 default_server;
    location / {
      proxy_pass http://app1/;
    }
    location /west/ {
      proxy_pass http://app1-west/;
    }
    location /east/ {
      proxy_pass http://app1-east/;
    }
  }

}
"@

############################ PowerShell ############################

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $nginxConfig
})
