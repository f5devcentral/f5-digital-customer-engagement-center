# Variables

# AWS Environment
variable "awsRegion" { default = "us-west-2" }
variable "projectPrefix" {
  type        = string
  description = "Creator of upgrade resources"
}
variable "resourceOwner" {
  type        = string
  description = "Email address of creator"
}
variable "AWSAccessKey" {
  type        = string
  description = "AWS Access Key used for API failover"
}
variable "AWSSecretKey" {
  type        = string
  description = "AWS Secret Key used for API failover"
}
variable "cfe_managed_route" { default = "0.0.0.0/0" }
variable "allowedIps" { default = "0.0.0.0/0" }
variable "allowed_mgmt_cidr" { default = "0.0.0.0/0" }

# BIGIP Image
# https://aws.amazon.com/marketplace/server/procurement?productId=15de6562-65b7-414e-a278-7258173d0791
variable "f5_ami_search_name" { default = "*F5 BIGIP-14.1*Best*200Mbps*" }
variable "ec2_instance_type" { default = "m4.xlarge" }

# BIGIP Setup
variable "f5_username" { default = "awsuser" }
// variable "ssh_key" {
//   type        = string
//   default     = "ssh-rsa ..."
//   description = "public key used for authentication in ssh-rsa format"
// }
