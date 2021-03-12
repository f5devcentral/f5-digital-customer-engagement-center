# provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// New Network
module "google_network" {
  source        = "../../../../../../modules/google/terraform/network/min"
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  projectPrefix = var.projectPrefix
  buildSuffix   = "random-cat"
}
// existing network
// data "google_compute_network" "vpc_network" {
//   name = "my-network-name"
// }
// data "google_compute_subnetwork" "subnet" {
//   name = "my-dubnet-name"
// }
// Nginx
module "nginx" {
  source               = "../../../../../../modules/google/terraform/nginx-plus"
  gcpProjectId         = var.gcpProjectId
  gcpRegion            = var.gcpRegion
  gcpZone              = var.gcpZone
  nginxCert            = var.nginxCert
  nginxKey             = var.nginxKey
  buildSuffix          = random_pet.buildSuffix.id
  vpc                  = module.google_network.vpcs["public"].id
  subnet               = module.google_network.subnets["public"].id
  adminAccountName     = var.adminAccountName
  adminAccountPassword = random_password.password.result
  sshPublicKey         = var.sshPublicKey
  #tags = ["mytag1","mytag2"]
  #sshPublicKey     = file("/home/user/mykey.pub")
  #image = "ubuntu-os-cloud/ubuntu-1804-lts"
  #instanceSize    = "n1-standard-2"
}
