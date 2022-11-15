using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

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
    # Output IP address for return variable
    $ip
  }
}

############################ Main ############################

# Variables
$keyVaultName = "${keyVaultName}"
$gitTokenSecretName = "${gitTokenSecretName}"
$gitRepoUrl = "${gitRepoUrl}"
$repoArray = $gitRepoUrl.Split("/")
$userName = $repoArray[3]
$repoFolder = $repoArray[4].Split(".")[0]
$tempFolder = "c:\home\data\temp"
$nginxUpstreamsFolder = "configs\upstreams"
$app1VmssConf = "app1-vmss.conf"
$app1WestVmssConf = "app1-west-vmss.conf"
$app1EastVmssConf = "app1-east-vmss.conf"

# Set git config
git config --global user.email "builduser@dummy.local" # any values will do, if missing commit will fail
git config --global user.name $userName

# Retrieve git token contents from Azure Key Vault
$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $gitTokenSecretName -AsPlainText
$token = "https://$${userName}:$${secret}@github.com/$${userName}/$${repoFolder}.git"

# Checkout repo (clone or pull)
if (Test-Path -Path $tempFolder\$repoFolder) {
    "Local repo exists. Updating the local copy."
    Set-Location -Path $tempFolder\$repoFolder -PassThru
    git pull 2>&1 | write-host
} else {
    "Local repo does not exist. Cloning repo."
    New-Item -Path $tempFolder -ItemType "directory"
    Set-Location -Path $tempFolder -PassThru
    git clone --depth=1 $gitRepoUrl -q
}

# Concatenate for less code later
$app1VmssConf = "$tempFolder\$repoFolder\$nginxUpstreamsFolder\$app1VmssConf"
$app1WestVmssConf = "$tempFolder\$repoFolder\$nginxUpstreamsFolder\$app1WestVmssConf"
$app1EastVmssConf = "$tempFolder\$repoFolder\$nginxUpstreamsFolder\$app1EastVmssConf"

# Reinitialize upstream conf files with simple comment for line 1
# Note: Remaining lines will be added with '-append'
$lineOneComment = "# auto-populated IP addresses from PowerShell"
Out-File -FilePath $app1VmssConf -InputObject $lineOneComment
Out-File -FilePath $app1WestVmssConf -InputObject $lineOneComment
Out-File -FilePath $app1EastVmssConf -InputObject $lineOneComment

# Get VM IP addresses in VMSS App West
#   1. add results to app west upstream conf (ex. for /west rule)
#   2. add results to main app1 upstream conf also (ex. for main pool)
Write-Host "Retrieving VMSS IP addresses for App West"
$resultAppWest = GetVmssIps -vmssName "${vmssAppWest}" -rgName "${rgWest}"
foreach ($ip in $resultAppWest)
{
  $server = "server " + $ip + ":80;" | Out-File $app1WestVmssConf -Append
  $server = "server " + $ip + ":80;" | Out-File $app1VmssConf -Append
}

# Get VM IP addresses in VMSS App East
#   1. add results to app east upstream conf (ex. for /east rule)
#   2. add results to main app1 upstream conf too as backup member (ex. for main pool)
Write-Host "Retrieving VMSS IP addresses for App East"
$resultAppEast = GetVmssIps -vmssName "${vmssAppEast}" -rgName "${rgEast}"
foreach ($ip in $resultAppEast)
{
  $server = "server " + $ip + ":80;" | Out-File $app1EastVmssConf -Append
  $server = "server " + $ip + ":80 backup;" | Out-File $app1VmssConf -Append
}

# Git status at start
git status 2>&1 | write-host

# Git add upstream conf changes
git add $app1VmssConf
git add $app1WestVmssConf
git add $app1EastVmssConf
git status 2>&1 | write-host

# Git commit
git commit -m "autoscale event" 2>&1 | write-host
git status 2>&1 | write-host

# Git push
git push $token 2>&1 | write-host

############################ HTTP Response ############################

# Output HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = "Azure Function Completed Successfully. Check GitHub actions!"
})
