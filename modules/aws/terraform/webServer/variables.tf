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
variable "jsScriptTag" {
  description = "script tag to embed in the nginx index.html file"
  type        = string
  default     = "<script async defer src='https://us.gimp.zeronaught.com/__imp_apg__/js/f5cs-a_aaW0IGtTsQ-2918f28d.js' id='_imp_apg_dip_'  ></script>"
}
