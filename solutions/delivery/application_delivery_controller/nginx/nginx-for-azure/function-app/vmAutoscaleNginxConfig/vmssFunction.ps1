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

    # Build server lines in upstream block
    #   Examples (adjust to your needs):
    #   server x.x.x.x 80;
    #   server x.x.x.x backup;
    $server = "server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80"

    # Append 'backup' to server line if flag is set
    if ($isBackup -eq "true") {
      $server = $server + " backup;"
    }
    else {
      $server = $server + ";"
    }

    # if only 1 VM, adjust indent
    if ($VMs.Length -eq 1) {
      "    " + $server
    }
    # if more than 1 VM and loop is last instance, adjust indent
    elseif ($count -eq 1) {
      "   " + $server
    }
    # if more than 1 VM and loop is first instance, adjust indent, add line feed
    elseif ($count -eq $VMs.Length) {
      "    " + $server + "`r`n"
      $count = $count - 1
    }
    # if more than 1 VM and loop is in middle of instances, adjust indent, add line feed
    else {
      "   " + $server + "`r`n"
      $count = $count - 1
    }
  }
}

# Get VM IP addresses in VMSS
Write-Host "Retrieving VMSS IP addresses for each VM instance."
$resultAppWest = GetVmssIps -vmssName "${vmssNameWest}" -rgName "${rgNameWest}"
$resultAppEast = GetVmssIps -vmssName "${vmssNameEast}" -rgName "${rgNameEast}"

# Get VM IP addresses in App East VMSS as backup member
Write-Host "Retrieving VMSS IP addresses for each VM instance as backup member."
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
Write-Host "Deploying nginx.conf via ARM template"
New-AzResourceGroupDeployment -Name nginxConfig `
  -ResourceGroupName ${rgNameShared} `
  -TemplateUri "https://raw.githubusercontent.com/nginxinc/nginx-for-azure-snippets/main/snippets/templates/configuration/single-file/azdeploy.json" `
  -nginxDeploymentName ${nginxDeploymentName} `
  -rootConfigFilePath "/etc/nginx/nginx.conf" `
  -rootConfigContent $nginxConfigEncoded
