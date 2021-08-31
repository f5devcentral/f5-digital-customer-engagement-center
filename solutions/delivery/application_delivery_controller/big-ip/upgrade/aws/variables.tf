# Variables

# AWS Environment
variable "awsRegion" { default = "us-west-2" }
variable "projectPrefix" { default = "upgrade" }
variable "resourceOwner" { default = "myname" }
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
variable "f5_ami_search_name" { default = "F5 Networks Licensed Hourly BIGIP-12.1.6*Best*200MBPS*" }
variable "ec2_instance_type" { default = "m4.xlarge" }

# BIGIP Setup
variable "f5_username" { default = "awsuser" }
// variable "ssh_key" {
//   type        = string
//   default     = "ssh-rsa ..."
//   description = "public key used for authentication in ssh-rsa format"
// }
