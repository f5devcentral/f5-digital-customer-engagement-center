
variable "prefix" {
  type        = string
  default     = "demo"
  description = "This value is inserted at the beginning of each Azure object (alpha-numeric, no special character)"
}
variable "location" {
  type        = string
  default     = "westus2"
  description = "Azure Location of the deployment"
}
variable "f5_ssh_publickey" {
  type        = string
  description = "instance key pair name (e.g. /.ssh/id_rsa.pub)"
}
variable "adminSrcAddr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Allowed Admin source IP prefix"
}
variable "instance_count" {
  default     = "2"
  description = "Number of F5 BIG-IP appliances to deploy behind Gateway Load Balancer"
}
variable "instance_count_app" {
  default     = "1"
  description = "Number of demo web app servers to deploy behind public Load Balancer"
}
variable "f5_username" {
  default     = "azureuser"
  description = "The admin username of the F5 BIG-IP that will be deployed"
}
variable "f5_password" {
  type        = string
  default     = "Default12345!"
  description = "Password for the Virtual Machine"
}
variable "f5_instance_type" {
  type        = string
  default     = "Standard_DS4_v2"
  description = "Azure instance type to be used for the BIG-IP VE"
}
variable "f5_version" {
  type        = string
  default     = "16.1.301000"
  description = "BIG-IP Version"
}
variable "lb_rules_ports" {
  type        = list(any)
  default     = ["22", "80", "443"]
  description = "List of ports to be opened by LB rules on public-facing LB."
}
variable "availabilityZones" {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list(any)
  default     = [1]
}

variable "availabilityZones_public_ip" {
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone."
  type        = string
  default     = "Zone-Redundant"
}
