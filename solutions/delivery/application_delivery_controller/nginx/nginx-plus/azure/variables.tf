resource "random_pet" "buildSuffix" {
  keepers = {
    prefix = var.prefix
  }
  separator = "-"
}

resource "random_id" "server" {
  byte_length = 2
}

variable "region" {
  description = "(optional) describe your variable"
  default     = "East US 2"
}

variable "location" {
  default = "eastus2"
}

variable "prefix" {
  description = "prefix for objects in project"
  default     = "demonginx"
}

variable "adminSourceAddress" {
  description = "admin source addresses"
  default     = ["0.0.0.0/0"]
}

variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
