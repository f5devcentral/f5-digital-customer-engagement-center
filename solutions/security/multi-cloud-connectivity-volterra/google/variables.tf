# project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  type        = string
  default     = null
  description = "random build suffix for resources"
}
variable "gcpRegion" {
  type        = string
  description = "region where gke is deployed"
}
variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}

variable "resourceOwner" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}

variable "business_units" {
  type = map(object({
    cidr = string
    mtu  = number
  }))
  default = {
    bu21 = {
      cidr = "10.1.0.0/16"
      mtu  = 1460
    }
    bu22 = {
      cidr = "10.1.0.0/16"
      mtu  = 1460
    }
    bu23 = {
      cidr = "10.1.0.0/16"
      mtu  = 1460
    }
  }
  description = <<EOD
The set of VPCs to create with overlapping CIDRs.
EOD
}

variable "hub_cidr" {
  type    = string
  default = "100.64.96.0/20"
}

variable "domain_name" {
  type        = string
  description = <<EOD
The DNS domain name that will be used as common parent generated DNS name of
loadbalancers.
EOD
}

variable "num_servers" {
  type        = number
  default     = 2
  description = <<EOD
The number of webserver instances to launch in each business unit spoke. Default
is 2.
EOD
}

variable "num_volterra_nodes" {
  type        = number
  default     = 1
  description = <<EOD
The number of Volterra gateway instances to launch in each business unit spoke.
Default is 1.
EOD
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional list of labels to apply to GCP resources.
EOD
}

variable "volterra_namespace" {
  type        = string
  description = <<EOD
The Volterra namespace into which Volterra resources will be managed.
EOD
}

variable "volterra_tenant" {
  type        = string
  description = <<EOD
The Volterra tenant to use.
EOD
}

variable "volterra_ssh_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional SSH key to add to Volterra nodes.
EOD
}
