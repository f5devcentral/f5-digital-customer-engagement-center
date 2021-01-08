# provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// Network
module "google_network" {
  source       = "../../../../../../infrastucture/google/terraform/network/min"
  gcpProjectId = var.gcpProjectId
  gcpRegion    = var.gcpRegion
  gcpZone      = var.gcpZone
  buildSuffix  = random_pet.buildSuffix.id
}

// Nginx
module "nginx" {
  source               = "../../../../../../infrastucture/google/terraform/nginx-plus"
  gcpProjectId         = var.gcpProjectId
  gcpRegion            = var.gcpRegion
  gcpZone              = var.gcpZone
  nginxCert            = var.nginxCert
  nginxKey             = var.nginxKey
  buildSuffix          = random_pet.buildSuffix.id
  vpc                  = module.google_network.vpcs["public"]
  subnet               = module.google_network.subnets["public"]
  adminAccountName     = "xadmin"
  adminAccountPassword = random_password.password.result
  sshPublicKey         = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
}
