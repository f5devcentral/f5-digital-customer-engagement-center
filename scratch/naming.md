# AUTO VARS
## project
projectPrefix type string
buildSuffix type string
  - random_id.hex
resourceOwner type string
  - name of the person or customer running the solution
## variables
 these resources will be present in each solutions variables.tf

resource "random_id" "buildSuffix" {
  keepers = {
    # Generate a new id each time we switch to a new project name
    prefix = var.projectPrefix
  }
  byte_length = 2
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
## admin
adminAccountName type string
adminSourceAddress type array
sshPublicKey type string
## cloud
gcpProjectId type string
gcpRegion type string
gcpZone type string
awsRegion type string
awsAz1 type string
awsAz2 type string
azureRegion type string
azureLocation type string
## nginx
nginxCert type string
nginxKey type string
controllerLicense type string
controllerAccount
controllerPass

# OUTPUTS
## network
vpcs type array
subnets type array
## resources
id?
name?
selflink?
guid?

# TAGGING
## objects
instances ?
resourceOwner type string
name array
    Name  = "${var.projectPrefix}-resource-${var.buildsuffix}"
    Owner = var.resourceOwner
