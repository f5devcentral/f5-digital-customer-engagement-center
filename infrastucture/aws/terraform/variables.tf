resource "random_id" "random-string" {
  byte_length = 4
}
variable "aws_az" {
  default = "us-east-1a"
}
variable "aws_region" {
  default = "us-east-1"
}
variable "aws_az1" {
  default = "us-east-1b"
}
variable "management_subnet_cidr" {
  description = "CIDR for the Management subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.3.0/24"
}

variable "kubernetes" {
  default = false
}
