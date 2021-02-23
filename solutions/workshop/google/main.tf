# provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// New Network
module "google_network" {
  for_each      = var.students
  source        = "../../../modules/google/terraform/network/min"
  projectPrefix = each.value.projectPrefix
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  buildSuffix   = random_pet.buildSuffix.id
}
// ssh keys
resource "tls_private_key" "student" {
  for_each  = var.students
  algorithm = "RSA"
  rsa_bits  = 4096
}

//workstation
module "jumphost" {
  for_each             = var.students
  source               = "../../../modules/google/terraform/jumphost/"
  gcpProjectId         = var.gcpProjectId
  projectPrefix        = each.value.projectPrefix
  adminAccountName     = each.key
  coderAccountPassword = random_password.password.result
  adminSourceAddress   = ["0.0.0.0/0"]
  sshPublicKey         = tls_private_key.student[each.key].public_key_openssh
  vpc                  = module.google_network[each.key].vpcs["public"]
  subnet               = module.google_network[each.key].subnets["public"]
  buildSuffix          = random_pet.buildSuffix.id
}
