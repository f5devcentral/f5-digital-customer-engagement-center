variable "prefix" {
  description = "prefix for objects in project"
  default     = "demonginx"
}
variable "buildSuffix" {
  description = "random build suffix for resources"
  default     = "random-cat"
}
variable "region" {
  description = "(optional) describe your variable"
  default     = "East US 2"
}
variable "location" {
  default = "eastus2"
}

variable "resource_group" {
  description = "resource group to create objects in"
}

variable "subnet" {
  description = "subnet to deploy in"
}
variable "adminAccountName" {
  description = "admin account"
  default     = "zadmin"
}
variable "adminPassword" {
  description = "admin password"
  default     = ""
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
resource "random_id" "server" {
  byte_length = 2
}

# nginx
variable "nginxInstanceType" {
  default = "Standard_DS2_v2"
}
variable "nginxDiskType" {
  default = "Premium_LRS"
}
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
variable "controllerAccount" {
  description = "name of controller admin account"
  default     = ""
}
variable "controllerPass" {
  description = "pass of controller admin account"
  default     = ""
}
variable "controllerAddress" {
  description = "ip4 address of controller to join"
  default     = "none"
}
# tags
variable "purpose" { default = "public" }
variable "environment" { default = "dev" } #ex. dev/staging/prod
variable "owner" { default = "dev" }
variable "group" { default = "dev" }
variable "costcenter" { default = "dev" }
variable "application" { default = "workspace" }
