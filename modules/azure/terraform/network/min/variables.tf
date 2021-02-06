variable "region" {
  default = "East US 2"
}

variable "location" {
  default = "eastus2"
}

variable "prefix" {
  description = "prefix for objects in project"
  default     = "azureDemo"
}

variable "cidr" {
  default = "10.1.0.0/16"
}

variable "subnets" {
  type = map(string)
  default = {
    "subnet1" = "10.1.1.0/24",
    "subnet2" = "10.1.10.0/24",
    "subnet3" = "10.1.20.0/24"
  }
}

variable "resource_group" {
  description = "resource group to create objects in"
}

variable "buildSuffix" {
  description = "random build suffix for resources"
  default     = "random-cat"
}
