resource "random_id" "id" {
  byte_length = 4
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
# project
variable "prefix" {
  default = "nginx-demo"
}
variable "aws_region" {
  default = "us-east-1"
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
# nginx
variable "nginxInstanceType" {
  default = "c4.xlarge"
}
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
variable "controllerAccount" {
  description = "name of controller admin account"
  default     = ""
}
variable "controllerPass" {
  description = "pass of controller admin account"
  default     = ""
}
variable "controllerAddress" {
  description = "ip4 address of controller to join"
  default     = "none"
}
