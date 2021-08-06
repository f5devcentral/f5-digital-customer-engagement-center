variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
}
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "resourceOwner" {
  type        = string
  description = "name of the person or customer running the solution"
}
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
