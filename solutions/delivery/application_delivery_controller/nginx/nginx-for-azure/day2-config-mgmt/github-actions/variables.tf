variable "buildSuffix" {
  type        = string
  description = "Build suffix for resources"
}
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "sshPublicKey" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "resourceOwner" {
  type        = string
  description = "name of the person or customer running the solution"
}
variable "rgShared" {
  type        = string
  description = "Name of the Shared Resource Group"
}
variable "rgAppWest" {
  type        = string
  description = "Name of the App West Resource Group"
}
variable "rgAppEast" {
  type        = string
  description = "Name of the App East Resource Group"
}
variable "vmssAppWest" {
  type        = string
  description = "Name of App West VMSS"
}
variable "vmssAppEast" {
  type        = string
  description = "Name of App East VMSS"
}
variable "nginxDeploymentName" {
  type        = string
  description = "Name of the NGINX deployment"
}
