#Project info
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "resourceOwner" {
  type        = string
  description = "name of the person or customer running the solution"
}

variable "business_units" {
  type = map(object({
    cidr           = list(any)
    subnetPrefixes = list(any)
    subnetNames    = list(any)
    workstation    = bool
  }))
  default = {
    bu11 = {
      cidr           = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
      workstation    = true
    }
    bu12 = {
      cidr           = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
      workstation    = false
    }
    bu13 = {
      cidr           = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
      workstation    = false
    }
  }
  description = "The set of VPCs to create with overlapping CIDRs."
}

#Azure info
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "num_servers" {
  type        = number
  default     = 1
  description = "number of instances to launch"
}

#Volterra info
variable "volterraTenant" {
  description = "Tenant of Volterra"
  type        = string
}
variable "volterraCloudCredAzure" {
  description = "Name of the volterra cloud credentials"
  type        = string
}
variable "namespace" {
  description = "Volterra application namespace"
  type        = string
}

variable "volterraVirtualSite" {
  type        = string
  description = <<EOD
The name of the Volterra virtual site that will receive LB registrations.
EOD
}

variable "domain_name" {
  type        = string
  description = <<EOD
The DNS domain name that will be used as common parent generated DNS name of
loadbalancers.
EOD
  default     = "shared.acme.com"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional list of labels to apply to Azure resources.
EOD
}
