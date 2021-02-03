# project
variable "projectPrefix" {
  description = "prefix for resources"
}
variable "gcpZone" {
  description = "zone where resource is deployed"
  default     = "us-east1-b"
}
variable "gcpRegion" {
  description = "region where resource is deployed"
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
  default     = "none"
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
  description = "comma seperated list of repositories to clone"
  default     = "https://github.com/vinnie357/f5-devops-workspace-gcp.git,https://github.com/f5devcentral/terraform-gcp-f5-sca.git"
}
variable "coderAccountPassword" {
  default = "pleaseUseVault123!!"
}
variable "terraformVersion" {
  default = "0.14.0"
}
