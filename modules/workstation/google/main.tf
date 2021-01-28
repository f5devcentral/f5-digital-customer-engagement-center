# provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// Network
module "google_network" {
  source       = "../../../modules/google/terraform/network/min"
  gcpProjectId = var.gcpProjectId
  gcpRegion    = var.gcpRegion
  gcpZone      = var.gcpZone
  buildSuffix  = random_pet.buildSuffix.id
}

// workstation
module "jumphost" {
  source           = "../../../modules/google/terraform/jumphost"
  prefix           = var.prefix
  gcpProjectId     = var.gcpProjectId
  gcpRegion        = var.gcpRegion
  gcpZone          = var.gcpZone
  buildSuffix      = random_pet.buildSuffix.id
  vpc              = module.google_network.vpcs["mgmt"]
  subnet           = module.google_network.subnets["mgmt"]
  adminAccountName = var.adminAccountName
  sshPublicKey     = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
  adminSourceAddress = var.adminSourceAddress
  repositories       = "https://github.com/f5devcentral/terraform-aws-f5-sca.git,https://github.com/f5devcentral/terraform-aws-bigip.git"
  onboardScript      = "https://raw.githubusercontent.com/vinnie357/bash-onboard-templates/master/nginx/gcp/onboard.sh.tpl"
}
