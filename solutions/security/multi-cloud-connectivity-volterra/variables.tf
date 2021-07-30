# Common solution variables
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "mcn-demo"
}

variable "buildSuffix" {
  type        = string
  default     = null
  description = "unique build suffix for resources; will be generated if empty or null"
}

variable "resourceOwner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}

variable "domain_name" {
  type        = string
  default     = "shared.acme.com"
  description = <<EOD
The DNS domain name that will be used as common parent generated DNS name of
loadbalancers. Default is 'shared.acme.com'.
EOD
}

# Volterra specific values; these will be used in each cloud module


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

# AWS specific vars - if these are not empty/null, AWS resources will be created

# Azure specific vars - if these are not empty/null, Azure resources will be created

# GCP Specific vars - if these are not empty/null, GCP resources will be created
variable "gcpRegion" {
  type        = string
  default     = null
  description = "region where GCP resources will be deployed"
}

variable "gcpProjectId" {
  type        = string
  default     = null
  description = "gcp project id"
}
