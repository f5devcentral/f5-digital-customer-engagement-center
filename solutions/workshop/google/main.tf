# provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// New Network
module "google_network_1" {
  source        = "../../../modules/google/terraform/network/min"
  projectPrefix = "student1"
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  gcpZone       = var.gcpZone
  buildSuffix   = random_pet.buildSuffix.id
}

// New Network
module "google_network_2" {
  source        = "../../../modules/google/terraform/network/min"
  projectPrefix = "student2"
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  gcpZone       = var.gcpZone
  buildSuffix   = random_pet.buildSuffix.id
}

// New Network
module "google_network_3" {
  source        = "../../../modules/google/terraform/network/min"
  projectPrefix = "student3"
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  gcpZone       = var.gcpZone
  buildSuffix   = random_pet.buildSuffix.id
}

//workstation
module "jumphost_1" {
  source               = "../../../modules/google/terraform/jumphost/"
  gcpProjectId         = var.gcpProjectId
  projectPrefix        = "student1"
  adminAccountName     = "student1"
  coderAccountPassword = random_password.password.result
  adminSourceAddress   = ["0.0.0.0/0"]
  sshPublicKey         = var.sshPublicKey
  vpc                  = module.google_network_1.vpcs["public"]
  subnet               = module.google_network_1.subnets["public"]
  buildSuffix          = random_pet.buildSuffix.id
}
//workstation
module "jumphost_2" {
  source               = "../../../modules/google/terraform/jumphost/"
  gcpProjectId         = var.gcpProjectId
  projectPrefix        = "student2"
  adminAccountName     = "student2"
  coderAccountPassword = random_password.password.result
  adminSourceAddress   = ["0.0.0.0/0"]
  sshPublicKey         = var.sshPublicKey
  vpc                  = module.google_network_2.vpcs["public"]
  subnet               = module.google_network_2.subnets["public"]
  buildSuffix          = random_pet.buildSuffix.id
}
//workstation
module "jumphost_3" {
  source               = "../../../modules/google/terraform/jumphost/"
  gcpProjectId         = var.gcpProjectId
  projectPrefix        = "student3"
  adminAccountName     = "student3"
  coderAccountPassword = random_password.password.result
  adminSourceAddress   = ["0.0.0.0/0"]
  sshPublicKey         = var.sshPublicKey
  vpc                  = module.google_network_3.vpcs["public"]
  subnet               = module.google_network_3.subnets["public"]
  buildSuffix          = random_pet.buildSuffix.id
}
