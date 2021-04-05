resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "projectPrefix" {
  description = "projectPrefix name for tagging"
  default     = "fw-inter-vpc"
}
variable "resourceOwner" {
  description = "Owner of the deployment for tagging purposes"
  default     = "elsa"
}
variable "awsRegion" {
  description = "aws region"
  type        = string
  default     = "us-east-2"
}
variable "sshPublicKey" {
  description = "SSH public key used to create an EC2 keypair"
  type        = string
  default     = null
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
