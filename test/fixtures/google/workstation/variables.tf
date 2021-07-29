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
  description = "region where resources are deployed"
}
variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}
variable "resourceOwner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
}
variable "variant" {
  type        = string
  description = "Workstation variant"
}
variable "users" {
  type        = list(string)
  default     = []
  description = "list of user emails to grant access to workstation"
}
variable "image" {
  type        = string
  default     = ""
  description = "Image self-link to override default base for VM"
}
