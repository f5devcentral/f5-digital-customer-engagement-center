# project
variable "prefix" {
  description = "prefix for resources"
}
variable "gcpZone" {
  description = "zone where gke is deployed"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
  default     = "us-east2"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
variable "buildSuffix" {
  description = "resource suffix"
}
variable "onboardScript" {
  description = "url for onboard script"
}

variable "name" {
  description = "device name"
  default     = "workspace"
}

variable "vpc" {
  description = "main vpc"
}
variable "subnet" {
  description = "main vpc subnet"
}
variable "deviceImage" {
  description = "gce image name"
  default     = "/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20200810"
}

variable "machineType" {
  description = " gce machine type/size"
  default     = "n1-standard-4"
  #default = "n1-standard-8"
}

variable "vm_count" {
  description = " number of devices"
  default     = 1
}

variable "adminSourceAddress" {
  description = "admin source range in CIDR"

}
variable "adminAccountName" {
  default = "admin"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}

variable "repositories" {
  default = "none"
}
