# vars
resource "random_pet" "buildSuffix" {
  keepers = {
    prefix = var.projectPrefix
  }
  length    = 2
  separator = "-"
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
# project
variable "projectPrefix" {
  description = "prefix for resources"
  default     = "workshop"
}
variable "gcpZone" {
  description = "zone where gke is deployed"
  default     = "us-east1-b"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
  default     = "us-east1"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
# admin
variable "adminSourceAddress" {
  description = "admin src address in cidr"
  default     = ["0.0.0.0/0"]
}
variable "adminAccountName" {
  description = "admin account"
}
variable "adminPassword" {
  description = "admin password"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
