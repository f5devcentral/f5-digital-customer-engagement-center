# project
variable "prefix" {
  description = "prefix for resources"
  default     = "demo-nginx"
}
variable "gcpZone" {
  description = "zone where gke is deployed"
  default     = "us-east1-b"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
  default     = "us-east1"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
variable "buildSuffix" {
  description = "random build suffix for resources"
  default     = "random-cat"
}
variable "instanceSize" {
  default = "n1-standard-4"
}
variable "tags" {
  default = ["nginx"]
}
variable "image" {
  #source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  default = "/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20200810"
}
# admin
variable "adminAccountName" {
  description = "admin account"
}
variable "adminAccountPassword" {
  description = "admin account password"
  default     = ""
}
variable "sshPublicKey" {
  description = "body of ssh public key used to access instances"
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
# controller
variable "controllerAccount" {
  description = "name of controller admin account"
  default     = ""
}
variable "controllerPassword" {
  description = "pass of controller admin account"
  default     = ""
}
variable "controllerAddress" {
  description = "ip4 address of controller to join"
  default     = "none"
}
# network
variable "vpc" {
  description = "vpc network to create resource in"
  default     = ""
}
variable "subnet" {
  description = " subnet to create resource in"
  default     = ""
}
