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

variable "subnets" {
  description = "List of subnet ids in which to deploy the server/s"
  type        = list(any)
  default     = null
}
variable "albSubnets" {
  description = "List of subnet ids in which to deploy the alb"
  type        = list(any)
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
  default     = "t3.large"
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
variable "associatePublicIp" {
  description = "choose if you want to associate a public ip to the instance"
  type        = bool
  default     = false
}
# onboarding
variable "startupCommand" {
  description = "Command to run at boot, used to start the app"
  type        = string
  default     = "docker run -d --restart always -p 80:3000 bkimminich/juice-shop"
}
variable "desiredCapacity" {
  description = "Desired number of server instances"
  type        = number
  default     = 1
}
variable "extraTags" {
  description = "Map of additional tags"
  type        = map(any)
  default = {
    "AdditionalKey" = "additionalValue"
  }
}
variable "user_data" {
  type        = string
  default     = null
  description = <<EOD
An optional cloud-config definition to apply to the launched instances. If empty
(default), a simple webserver will be launched that displays the hostname of the
instance that serviced the request.
EOD
}
