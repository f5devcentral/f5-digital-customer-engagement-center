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
  foreach ($vm in $VMs)
  {
    $resourceName = $vmssName + "/" + $VM.InstanceId + "/" + $nicName
    $target = Get-AzResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-03-30

    # Build server lines in upstream block
    # Examples (adjust to your needs...do not append ';' yet):
    #   server x.x.x.x:80
    #   server x.x.x.x:80 weight=5
    #   server x.x.x.x:8080
    $server = "server " + $target.Properties.ipConfigurations[0].properties.privateIPAddress + ":80"

    # Append ';' or 'backup;' to server line depending if flag is set
    if ($isBackup -ne "true") {
      $server + ";"
    }
    else {
      $server + " backup;"
    }
  }
}

# Get VM IP addresses in VMSS
Write-Host "Retrieving VMSS IP addresses for each VM instance."
$resultAppWest = GetVmssIps -vmssName "${vmssAppWest}" -rgName "${rgWest}"
$resultAppEast = GetVmssIps -vmssName "${vmssAppEast}" -rgName "${rgEast}"

# Get VM IP addresses in App East VMSS as backup member
Write-Host "Retrieving VMSS IP addresses for each VM instance as backup member."
$resultAppEastBackup = GetVmssIps -vmssName "${vmssAppEast}" -rgName "${rgEast}" -isBackup "true"

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

############################ Deploy ARM Template ############################

# Convert nginx config to base 64
$convertBytes = [System.Text.Encoding]::UTF8.GetBytes($nginxConfig)
$nginxConfigEncoded = [Convert]::ToBase64String($convertBytes)

# Deploy nginx Config via ARM template
Write-Host "Deploying nginx.conf via ARM template"
New-AzResourceGroupDeployment -Name nginxConfig `
  -ResourceGroupName ${rgShared} `
  -TemplateUri "https://raw.githubusercontent.com/nginxinc/nginx-for-azure-snippets/main/snippets/templates/configuration/single-file/azdeploy.json" `
  -nginxDeploymentName ${nginxDeploymentName} `
  -rootConfigFilePath "/etc/nginx/nginx.conf" `
  -rootConfigContent $nginxConfigEncoded

############################ HTTP Response ############################

# Output HTTP response of nginx.conf
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $nginxConfig
})
