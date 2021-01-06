resource "random_id" "random-string" {
  byte_length = 4
}

variable "user_id" {
  default = "xadmin"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_az" {
  default = "eu-central-1a"
}

variable "aws_az1" {
  default = "eu-central-1b"
}
