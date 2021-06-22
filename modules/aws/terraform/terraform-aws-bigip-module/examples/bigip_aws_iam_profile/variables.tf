variable "ec2_key_name" {
  description = "AWS EC2 Key name for SSH access"
  type        = string
  default     = "tf-demo-key"
}

variable "prefix" {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "tf-aws-bigip"
}
variable "region" {}

variable "cidr" {
  description = "aws VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}


variable "availabilityZones" {
  description = "If you want the VM placed in an AWS Availability Zone, and the AWS region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b"]
}
variable "AllowedIPs" {}

variable "instance_count" {
  description = "Number of Bigip instances to create( From terraform 0.13, module supports count feature to spin mutliple instances )"
  type        = number
  default     = 1
}
