# Azure VNet Inputs
variable "azureVnet" {
  type = object({
    cidr          = string
    azureZones    = list(string)
    azureRegion   = string
    azureLocation = string
  })
}

variable "azureResourceGroup" {
  description = "resource group to create objects in"
}

# Project Tagging
variable "context" {
  type = object({
    resourceOwner = string
    random        = string
  })
}

# Offsets use for the calculated subnet ranges
variable "offsets" {
  type = object({
    management = number
    external   = number
    internal   = number
  })

  default = {
    management = 1
    external   = 10
    internal   = 20
  }
}