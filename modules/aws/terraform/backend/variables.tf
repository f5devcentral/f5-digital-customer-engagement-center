# project
variable "projectPrefix" {
  default = "f5-dcec"
}
# network
variable "vpc" {
}

variable "mgmtSubnet" {
}
variable "securityGroup" {
  default = null
}
# instance
variable "instanceType" {
  default = "t3.large"
}
variable "resourceOwner" {
  description = "tag used to mark instance owner"
  default     = "f5-dcec-user"
}
# admin
variable "adminAccountName" {
  description = "admin account name used with instance"
  default     = null
}
variable "keyName" {
  description = "instance key pair name"
}
variable "coderAccountPassword" {
  default = "pleaseUseVault123!!"
}
# onboarding
variable "onboardScript" {
  description = "URL to userdata onboard script"
  default     = "https://raw.githubusercontent.com/vinnie357/workspace-onboard-bash-templates/master/terraform/aws/sca/onboard.sh"
}
variable "repositories" {
  description = "comma seperated list of git repositories to clone"
  default     = "https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"
}
variable "terraformVersion" {
  default = "0.14.0"
}

variable "associateEIP" {
  description = "choose if you want to associate an EIP to the instance"
  type        = bool
  default     = true
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
