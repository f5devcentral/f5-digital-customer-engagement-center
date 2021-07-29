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
  description = "region where resources will be deployed"
}
variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}
variable "resourceOwner" {
  type        = string
  default     = "f5-dcec"
  description = "owner of GCP resources"
}
