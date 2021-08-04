# project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "buildSuffix" {
  type        = string
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
  type        = string
  description = "owner of the deployment, for tagging purposes"
}

variable "business_units" {
  type = map(object({
    cidr        = string
    mtu         = number
    workstation = bool
  }))
  default = {
    bu21 = {
      cidr        = "10.1.0.0/16"
      mtu         = 1460
      workstation = true
    }
    bu22 = {
      cidr        = "10.1.0.0/16"
      mtu         = 1460
      workstation = false
    }
    bu23 = {
      cidr        = "10.1.0.0/16"
      mtu         = 1460
      workstation = false
    }
  }
  description = <<EOD
The set of VPCs to create with overlapping CIDRs.
EOD
}

variable "outside_cidr" {
  type        = string
  default     = "100.64.96.0/20"
  description = <<EOD
The CIDR to assign to shared outside VPC. Default is '100.64.96.0/20'.
EOD
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

variable "namespace" {
  type        = string
  description = <<EOD
The Volterra namespace into which Volterra resources will be managed.
EOD
}

variable "volterraTenant" {
  type        = string
  description = <<EOD
The Volterra tenant to use.
EOD
}

variable "ssh_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional SSH key to add to Volterra nodes.
EOD
}

variable "volterraVirtualSite" {
  type        = string
  description = <<EOD
The name of the Volterra virtual site that will receive LB registrations.
EOD
}

variable "assisted" {
  description = "Use Assisted deployment for Volterra GCP Site"
  default     = false
}
