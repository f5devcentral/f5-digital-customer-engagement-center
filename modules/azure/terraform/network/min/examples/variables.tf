variable "region" {
  default = "East US 2"
}

variable "location" {
  default = "eastus2"
}

variable "prefix" {
  default = "azureDemo"
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}
