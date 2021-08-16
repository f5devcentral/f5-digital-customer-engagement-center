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
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "coderAccountPassword" {
  type        = string
  description = "password used to access VSCode code-server via web"
  default     = "pleaseUseVault123!!"
}

# onboarding
variable "repositories" {
  type        = string
  description = "comma seperated list of git repositories to clone"
  default     = ""
}
variable "terraformVersion" {
  type        = string
  description = "terraform version to install on jumphost"
  default     = "0.14.10"
}
