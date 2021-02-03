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
