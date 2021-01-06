resource "random_id" "random-string" {
  byte_length = 4
}

variable "user_id" {
  default = "xadmin"
}
variable "admin_source_cidr" {
  default = "0.0.0.0/0"
}
variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_az1" {
  default = "eu-central-1a"
}

variable "aws_az2" {
  default = "eu-central-1b"
}

variable "kubernetes" {
  default     = true
  description = " deploy a kubernetes cluster or not"
}
variable "cluster_name" {
  default     = "my-cluster"
  description = "eks cluster name"
}
