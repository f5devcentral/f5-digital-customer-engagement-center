variable "instanceType" {
  default = "m4.xlarge"
}

variable "securityGroup" {
}

variable "mgmt_vpc" {
}

variable "mgmt_subnet" {
}

variable "key_name" {
}

variable "projectPrefix" {
  default = "workspace-"
}

variable "buildSuffix" {
}
variable "onboardScript" {
  description = "URL to userdata onboard script"
  default     = "https://raw.githubusercontent.com/vinnie357/workspace-onboard-bash-templates/master/terraform/aws/sca/onboard.sh"
}
variable "repositories" {
  description = "comma seperated list of git repositories to clone"
  default     = "https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"
}
