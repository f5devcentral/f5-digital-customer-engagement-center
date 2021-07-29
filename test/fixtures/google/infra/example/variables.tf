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
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}
variable "expected_main_equiv" {
  type        = string
  default     = "mgmt"
  description = "Expected main VPC equivalent"
}

# These are not used but expected by inspec controls; set to default values of
# infra module.

variable "vpc_options" {
  type = object({
    mgmt = object({
      primary_cidr = string
      mtu          = number
      nat          = bool
    })
    private = object({
      primary_cidr = string
      mtu          = number
      nat          = bool
    })
    public = object({
      primary_cidr = string
      mtu          = number
      nat          = bool
    })
  })
  default = {
    mgmt = {
      primary_cidr = "10.0.10.0/24"
      mtu          = 1460
      nat          = true
    }
    private = {
      primary_cidr = "10.0.20.0/24"
      mtu          = 1460
      nat          = false
    }
    public = {
      primary_cidr = "10.0.30.0/24"
      mtu          = 1460
      nat          = false
    }
  }
  description = "VPC features to supply to infra module"
}

variable "features" {
  type = object({
    workstation = bool
    isolated    = bool
    registry    = bool
  })
  default = {
    workstation = true
    isolated    = false
    registry    = false
  }
  description = "Behavioural features to supply to infra module"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Optional labels to add in addition to those set by infra"
}

variable "users" {
  type        = list(string)
  default     = []
  description = "list of user emails to grant access to workstation"
}
