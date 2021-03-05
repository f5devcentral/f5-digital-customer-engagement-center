#project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
variable "resourceOwner" {
  description = "name of the person or customer running the solution"
}
resource "random_id" "randomString" {
  byte_length = 4
}
#Azure VNet Inputs
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}

variable "region" {
  description = "(optional) describe your variable"
  default     = "East US 2"
}

variable "location" {
  default = "eastus2"
}

# admin
variable "adminAccountName" {
  description = "admin account"
  default     = "zadmin"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
variable "adminSourceAddress" {
  description = "admin source addresses"
  default     = ["0.0.0.0/0"]
}

# nginx
variable "nginxKey" {
  description = "key for nginxplus"
  default     = ""
}
variable "nginxCert" {
  description = "cert for nginxplus"
  default     = ""
}
