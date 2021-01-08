resource "random_id" "random-string" {
  byte_length = 4
}
# project
variable "prefix" {
  default = "nginx-demo"
}
variable "admin_source_cidr" {
  default = "0.0.0.0/0"
}
variable "aws_region" {
  default = "us-east-2"
}

variable "aws_az1" {
  default = "us-east-2a"
}

variable "aws_az2" {
  default = "us-east-2b"
}
