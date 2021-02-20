#project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "resourceOwner" {
  description = "name of the person or customer running the solution"
}

#Azure VNet Inputs
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}
variable "azureCidr" {
  type        = string
  description = "VNet CIDR range"
}
variable "azureSubnets" {
  type = object({
    management = string
    external   = string
    internal   = string
  })
}