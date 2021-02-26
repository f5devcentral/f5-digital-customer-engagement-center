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

#Azure VNet Inputs
variable "azureCidr" {
  type        = string
  description = "VNet CIDR range"
  default     = "10.1.0.0/16"
}
variable "azureSubnets" {
  type = object({
    mgmt     = string
    external = string
    internal = string
  })
  default = {
    mgmt     = "10.1.1.0/24"
    external = "10.1.10.0/24"
    internal = "10.1.20.0/24"
  }
}
