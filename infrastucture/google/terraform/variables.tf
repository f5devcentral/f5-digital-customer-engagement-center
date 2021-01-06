# project
resource "random_pet" "buildSuffix" {
  keepers = {
    prefix = var.prefix
  }
  length    = 2
  separator = "-"
}

variable "prefix" {
  description = "prefix for resources"
  default     = "demo-"
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
variable "kubernetes" {
  default = false
}

variable "gkeVersion" {
  description = "GKE release version"
  default     = "1.16.15-gke.1600"
}

variable "podCidr" {
  description = "k8s pod cidr"
  default     = "10.56.0.0/14"
}
