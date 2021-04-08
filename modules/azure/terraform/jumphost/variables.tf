#project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "resourceOwner" {
  description = "name of the person or customer running the solution"
}

#Azure Resource Group
variable "azureResourceGroup" {
  description = "resource group to create objects in"
}
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}

#Azure Network
variable "mgmtSubnet" {
  type        = string
  description = "subnet for virtual machine"
}
variable "securityGroup" {
  type        = string
  description = "security group for virtual machine"
}

# instance
variable "instanceType" {
  description = "instance type for virtual machine"
  default = "Standard_B2ms"
}

# admin
variable "adminAccountName" {
  description = "admin account name used with instance"
  default     = "ubuntu"
}
variable "keyName" {
  description = "instance key pair name"
}
variable "coderAccountPassword" {
  default = "pleaseUseVault123!!"
}

# onboarding
variable "repositories" {
  description = "comma seperated list of git repositories to clone"
  default     = null
}
variable "terraformVersion" {
  default = "0.14.10"
}
