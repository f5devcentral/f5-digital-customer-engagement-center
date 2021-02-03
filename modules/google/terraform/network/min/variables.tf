# project
variable "projectPrefix" {
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  description = "random build suffix for resources"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
