
variable "awsRegion" {
  default = "us-west-2"
}

variable "projectPrefix" {
  default = "singleVpcWorkstation"
}

variable "resourceOwner" {
  default = "elsa"
}

variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "jsScriptTag" {
  description = "js script tag for deviceid"
  default     = "/__imp_apg__/js/f5cs-a_aaW0IGtTsQ-2918f28d.js"
}
variable "domainName" {
  description = "domain name that route53 manages - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html"
  type        = string
  default     = null
}
variable "subDomain" {
  description = "subdomain, used to create the A record of the site under your domain"
  type        = string
  default     = "cfdeviceid"
}
