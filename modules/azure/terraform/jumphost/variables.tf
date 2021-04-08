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
  type        = string
  description = "name of the person or customer running the solution"
}

#Azure Resource Group
variable "azureResourceGroup" {
  type        = string
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
  type        = string
  description = "instance type for virtual machine"
  default     = "Standard_DS3_v2"
}

# admin
variable "adminAccountName" {
  type        = string
  description = "admin account name used with instance"
  default     = "ubuntu"
}
variable "keyName" {
  type        = string
  description = "instance key pair name"
}
variable "coderAccountPassword" {
  type    = string
  default = "pleaseUseVault123!!"
}

# onboarding
variable "repositories" {
  type        = string
  description = "comma seperated list of git repositories to clone"
  default     = ""
}
variable "terraformVersion" {
  type    = string
  default = "0.14.10"
}
