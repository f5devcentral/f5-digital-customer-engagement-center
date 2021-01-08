resource "random_pet" "buildSuffix" {
  keepers = {
    prefix = var.prefix
  }
  separator = "-"
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
# project
variable "prefix" {
  description = "prefix for resources"
}
variable "gcpZone" {
  description = "zone where gke is deployed"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
}
variable "gcpProjectId" {
  description = "gcp project id"
}

# admin
variable "adminSourceAddress" {
  description = "admin src address in cidr"
  default     = ["0.0.0.0/0"]
}
variable "adminAccount" {
  description = "admin account"
}
variable "adminPassword" {
  description = "admin password"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
