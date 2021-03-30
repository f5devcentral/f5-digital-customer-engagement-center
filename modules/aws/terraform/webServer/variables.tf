# project
variable "projectPrefix" {
  description = "Prefix used in tags to identify the project"
  type        = string
  default     = "f5-dcec"
}
# network
variable "vpc" {
  description = "Vpc id in which to deploy the server"
  type        = string
  default     = null
}

variable "mgmtSubnet" {
  description = "subnet id in which to deploy the server"
  type        = string
  default     = null
}
variable "securityGroup" {
  description = "security group id that will be associated with the server"
  type        = string
  default     = null
}
# instance
variable "instanceType" {
  description = "AWS instance type"
  type        = string
  default = "t3.large"
}
variable "resourceOwner" {
  description = "tag used to mark instance owner"
  type        = string
  default     = "f5-dcec-user"
}
variable "keyName" {
  description = "instance key pair name"
  type        = string
  default     = null
}
variable "associateEIP" {
  description = "choose if you want to associate an EIP to the instance"
  type        = bool
  default     = true
}
# onboarding
variable "startupCommand" {
  description = "Command to run at boot, used to start the app"
  type        = string
  default     = "docker run -d --restart always -p 80:3000 bkimminich/juice-shop"
}