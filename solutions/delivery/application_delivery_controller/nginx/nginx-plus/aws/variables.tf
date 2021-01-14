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
# admin
variable "adminAccountName" {
  description = "admin account"
  default     = "zadmin"
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
variable "ec2KeyName" {
  default = ""
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
#controller
variable "controllerAccount" { default = "" }
variable "controllerPass" { default = "" }
variable "dbuser" { default = "" }
variable "dbpass" { default = "" }
variable "controllerLicense" {
  type    = string
  default = <<-EOT
PASTE CONTROLLER LICENSE HERE
    EOT
}
