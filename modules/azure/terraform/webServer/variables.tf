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
variable "subnet" {
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
  default     = "Standard_B2ms"
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

# onboarding
variable "startupCommand" {
  description = "Command to run at boot, used to start the app"
  type        = string
  default     = "docker run -d --restart always -p 80:3000 bkimminich/juice-shop"
}
