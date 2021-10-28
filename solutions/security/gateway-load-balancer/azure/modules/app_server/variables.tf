variable "location" {default = "East US 2"}
variable "resource_group_name" {default = "my-demo-resource-group"}
variable "subnet_id" {}
variable "vm_name" {}
variable "vm_size" {default = "Standard_DS1_v2"}
variable "f5_ssh_publickey" {
  description = "public key to be used for ssh access to the VM. e.g. c:/home/id_rsa.pub"
}
variable "upassword" {
  description = "admin password for VM"
}

