# project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "demo"
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

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional map of key:value strings that will be applied to resources as labels,
where supported.
EOD
}

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
  description = <<EOD
Allow module consumers to override the VPC features and addressing scheme used by
infra. The default values will generate a set of three management, public, and
private VPCs that use the same CIDR ranges and MTU as `network/min`.
EOD
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
  description = <<EOD
Allow module cconsumers to modify the default behaviour of infra module.
  workstation: boolean to toggle creation of a `workstation` VM that can be used
               for development, testing, and a proxy for BIG-IP, GKE, etc.
               Enabled by default.
  isolated:    boolean to toggle creation of an `isolated` set of VPCs and the
               required supporting infrastructure (private DNS). Disabled by default.
  registry:    boolean to toggle enablement of Google Artifact Registry for
               container storage and helm charts. Disabled by default.
EOD
}

variable "workstation_options" {
  type = object({
    vpc = string
  })
  default = {
    vpc = "main"
  }
  description = <<EOD
Allow module consumers to override the default workstation features
EOD
}
