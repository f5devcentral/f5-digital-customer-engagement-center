# variables
resource "random_id" "randomString" {
  byte_length = 4
}
# project
variable "projectPrefix" {
  default = "nginx-controller-demo"
}
variable "admin_source_cidr" {
  default = "0.0.0.0/0"
}
# aws
variable "resourceOwner" {
  description = "tag used to mark instance owner"
  default     = "dcec-kic-user"
}
variable "awsRegion" {
  default = "us-east-2"
}

variable "awsAz1" {
  default = "us-east-2a"
}

variable "awsAz2" {
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
variable "controller_install_file_name" {
  default = "controller-installer-3.12.1.tar.gz"
}
# bucket
variable "s3_bucket_name" {
  default     = "demo_bucket"
  description = "s3 bucket with controller installer"
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
