variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "resourceOwner" {
  type        = string
  description = "name of the person or customer running the solution"
}
variable "azureResourceGroup" {
  type        = string
  description = "resource group to create objects in"
}
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}
variable "azureZones" {
  type        = list(any)
  description = "The list of availability zones in a region"
  default     = [1, 2, 3]
}
variable "zone" {
  type        = string
  default     = ""
  description = "The availability zone where the server will be deployed. If empty (default), instances will be randomly assigned from zones found in variable 'azureZones'."
}
variable "subnet" {
  type        = string
  description = "subnet for virtual machine"
}
variable "securityGroup" {
  type        = string
  description = "security group for virtual machine"
}
variable "instanceType" {
  type        = string
  description = "instance type for virtual machine"
  default     = "Standard_B2ms"
}
variable "public_address" {
  type        = bool
  default     = false
  description = "If true, an ephemeral public IP address will be assigned to the webserver. Default value is 'false'. "
}
variable "adminAccountName" {
  type        = string
  description = "admin account name used with instance"
  default     = "ubuntu"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "user_data" {
  type        = string
  default     = null
  description = "An optional cloud-config definition to apply to the launched instances. If empty (default), a simple webserver will be launched that displays the hostname of the instance that serviced the request."
}
variable "name" {
  type        = string
  default     = null
  description = "The name to assign to the server VM. If left empty(default), a name will be generated as '{projectPrefix}-backend-{buildSuffix}' where {projectPrefix} and {buildSuffix} will be the values of the respective variables."
}
