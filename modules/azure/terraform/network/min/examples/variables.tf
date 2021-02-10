# Azure VNet Inputs
variable "azureVnet" {
  type = object({
    cidr          = string
    azureZones    = list(string)
    azureRegion   = string
    azureLocation = string
  })
}

# Project Tagging
variable "context" {
  type = object({
    resourceOwner = string
    random        = string
  })
}