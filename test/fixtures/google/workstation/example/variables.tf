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
# Unused, but include so Terraform doesn't complain about undefined variable.
variable "users" {
  type        = list(string)
  default     = []
  description = "list of user emails to grant access to workstation"
}
