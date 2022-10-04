variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "resourceOwner" {
  type        = string
  description = "name of the person or customer running the solution"
}

variable "vnets" {
  type = map(object({
    cidr           = list(any)
    subnetPrefixes = list(any)
    subnetNames    = list(any)
    location       = string
  }))
  default = {
    shared = {
      cidr           = ["10.255.0.0/16"]
      subnetPrefixes = ["10.255.0.0/24"]
      subnetNames    = ["default"]
      location       = "eastus2"
    }
    appWest = {
      cidr           = ["10.100.0.0/16"]
      subnetPrefixes = ["10.100.0.0/24"]
      subnetNames    = ["default"]
      location       = "westus2"
    }
    appEast = {
      cidr           = ["10.101.0.0/16"]
      subnetPrefixes = ["10.101.0.0/24"]
      subnetNames    = ["default"]
      location       = "eastus2"
    }
  }
  description = "The set of VNets to create"
}
variable "adminName" {
  type        = string
  description = "admin account name used with app server instance"
  default     = "azureuser"
}

variable "sshPublicKey" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "num_servers" {
  type        = number
  default     = 1
  description = "number of instances to launch"
}
variable "domain_name" {
  type        = string
  description = "The DNS domain name that will be used in Azure private DNZ zone for VM names"
  default     = "shared.acme.com"
}
