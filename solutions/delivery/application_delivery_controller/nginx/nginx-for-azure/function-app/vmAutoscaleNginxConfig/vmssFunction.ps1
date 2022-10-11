############################ Powershell ############################

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Function GetVmssIps
#     Retrieve VM Ip addresses from VMSS and builds
#     upstream block for nginx.conf file
function GetVmssIps {
  param ($vmssName, $rgName, $isBackup)
  $VMs = Get-AzVmssVM -ResourceGroupName $rgName -VMScaleSetName $vmssName
  $nicName = ($VMs[0].NetworkProfile.NetworkInterfaces[0].Id).Split('/')[-1]
  $count = $VMs.Length
  foreach ($vm in $VMs)
  {
    $resourceName = $vmssName + "/" + $VM.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30
    if ($VMs.Length -eq 1) {
      if ($isBackup -eq "true") { "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;" }
      else { "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;" }
    }
    elseif ($count -eq 1) {
      if ($isBackup -eq "true") { "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;" }
      else { "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;" }
    }
    elseif ($count -eq $VMs.Length) {
      if ($isBackup -eq "true") { "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;`r`n" }
      else { "    server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n" }
      $count = $count - 1
    }
    else {
      if ($isBackup -eq "true") { "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80 backup;`r`n" }
      else { "   server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80;`r`n" }
      $count = $count - 1
    }
  }
}

# Retrieve VM IP address in each VMSS
$resultAppWest = GetVmssIps -vmssName "${vmssNameWest}" -rgName "${rgNameWest}"
$resultAppEast = GetVmssIps -vmssName "${vmssNameEast}" -rgName "${rgNameEast}"

# Retrieve VM IP address in backup VMSS
$resultAppEastBackup = GetVmssIps -vmssName "${vmssNameEast}" -rgName "${rgNameEast}" -isBackup "true"

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

############################ Deploy ARM Template ############################

# Convert nginx config to base 64
$convertBytes = [System.Text.Encoding]::UTF8.GetBytes($nginxConfig)
$nginxConfigEncoded = [Convert]::ToBase64String($convertBytes)

# Deploy nginx Config via ARM template
New-AzResourceGroupDeployment -Name nginxConfig `
  -ResourceGroupName ${rgNameShared} `
  -TemplateUri "https://raw.githubusercontent.com/nginxinc/nginx-for-azure-snippets/main/snippets/templates/configuration/single-file/azdeploy.json" `
  -nginxDeploymentName ${nginxDeploymentName} `
  -rootConfigFilePath "/etc/nginx/nginx.conf" `
  -rootConfigContent $nginxConfigEncoded
