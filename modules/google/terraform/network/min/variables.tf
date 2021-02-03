# project
resource "random_pet" "buildSuffix" {
  keepers = {
    prefix = var.projectPrefix
  }
  length    = 2
  separator = "-"
}

variable "projectPrefix" {
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  description = "random build suffix for resources"
  default     = "random-cat"
}
variable "gcpZone" {
  description = "zone where gke is deployed"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
