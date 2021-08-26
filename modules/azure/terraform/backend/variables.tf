#project
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

#Azure Resource Group
variable "azureResourceGroup" {
  type        = string
  description = "resource group to create objects in"
}
variable "azureLocation" {
  type        = string
  description = "location where Azure resources are deployed (abbreviated Azure Region name)"
}

#Azure Network
variable "subnet" {
  type        = string
  description = "subnet for virtual machine"
}
variable "securityGroup" {
  type        = string
  description = "security group for virtual machine"
}

# instance
variable "instanceType" {
  type        = string
  description = "instance type for virtual machine"
  default     = "Standard_B2ms"
}
variable "public_address" {
  type        = bool
  default     = false
  description = <<EOD
If true, an ephemeral public IP address will be assigned to the webserver. Default value is 'false'.
EOD
}

# admin
variable "adminAccountName" {
  type        = string
  description = "admin account name used with instance"
  default     = "ubuntu"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}

# onboarding
variable "user_data" {
  type        = string
  default     = null
  description = <<EOD
An optional cloud-config definition to apply to the launched instances. If empty (default), a simple webserver will be launched that displays the hostname of the instance that serviced the request.
EOD
}