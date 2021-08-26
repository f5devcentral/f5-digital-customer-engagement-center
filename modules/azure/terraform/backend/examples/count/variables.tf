variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
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
variable "public_address" {
  type        = bool
  default     = false
  description = "If true, an ephemeral public IP address will be assigned to the webserver. Default value is 'false'. "
}
variable "num_servers" {
  type        = number
  default     = 2
  description = "number of instances to launch"
}
