resource "random_id" "id" {
  byte_length = 4
}
variable "random_id" {
  default = "21314"
}
# project
variable "projectPrefix" {
  default = "nginx-demo"
}
variable "aws_region" {
  default = "us-east-2"
}
variable "resourceOwner" {
  description = "tag used to mark instance owner"
  default     = "dcec-controller-user"
}
#network
variable "subnet" {
  description = "subnet where instance is created"
  default     = "main"
}
variable "vpc" {
  description = "vpc where instance is created"
  default     = "main"
}
variable "securityGroup" {
  description = "security group for instance"
  default     = "none"
}
# admin
variable "adminAccountName" {
  description = "admin account"
  default     = "zadmin"
}
variable "adminPassword" {
  description = "admin password"
  default     = ""
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
variable "ec2KeyName" {
  default = ""
}
#variables for secrets for controller
variable "dbuser" { default = "" }
variable "dbpass" { default = "" }
variable "controllerLicense" {
  type    = string
  default = <<-EOT
PASTE CONTROLLER LICENSE HERE
    EOT
}
variable "controllerAccount" {
  description = "name of controller admin account"
  default     = ""
}
variable "controllerPass" {
  description = "pass of controller admin account"
  default     = ""
}
variable "bucketId" {
  description = "s3 bucket id where installer tar is"
  default     = "none"
}
variable "bucketFileId" {
  description = "file id where installer tar is"
  default     = "none"
}
