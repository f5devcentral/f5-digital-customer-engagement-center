variable "region" {
  description = "(optional) describe your variable"
  default     = "East US 2"
}

variable "prefix" {
  description = "prefix for objects in project"
  default     = "demonginx"
}
variable "location" {
  default = "eastus2"
}
variable "cidr" {
  default = "10.90.0.0/16"
}

variable "subnets" {
  type = map(string)
  default = {
    "subnet1" = "10.90.1.0/24"
  }
}
variable "resource_group" {
  description = "resource group to create objects in"
}
variable "buildSuffix" {
  description = "random build suffix for resources"
  default     = "random-cat"
}
