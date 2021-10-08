variable "buildSuffix" {
  type        = string
  default     = null
  description = "random build suffix for resources"
}
variable "projectPrefix" {
  type        = string
  description = "projectPrefix name for tagging"
}
variable "resourceOwner" {
  type        = string
  description = "Owner of the deployment for tagging purposes"
}
variable "awsRegion" {
  description = "aws region"
  type        = string
}
variable "ssh_key" {
  description = "SSH public key used to create an EC2 keypair"
  type        = string
  default     = null
}
variable "awsAz1" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "awsAz2" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "awsAz3" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "volterraP12" {
  description = "Location of volterra p12 file"
  type        = string
  default     = null
}
variable "volterraUrl" {
  description = "url of volterra api"
  type        = string
  default     = null
}
variable "volterraTenant" {
  description = "Tenant of Volterra"
  type        = string
}
variable "volterraCloudCredAWS" {
  description = "Name of the volterra aws credentials"
  type        = string
}
variable "namespace" {
  description = "Volterra application namespace"
  type        = string
}
variable "domain_name" {
  type        = string
  description = "The DNS domain name that will be used as common parent generated DNS name of loadbalancers."
  default     = "shared.acme.com"
}
variable "spokeVPCs" {
  type = map(object({
    cidr            = string
    public_subnets  = list(any)
    private_subnets = list(any)
    workstation     = bool
  }))
  default = {
    bu1 = {
      cidr            = "10.1.0.0/16"
      public_subnets  = ["10.1.10.0/24", "10.1.110.0/24"]
      private_subnets = ["10.1.52.0/24", "10.1.152.0/24"]
      workstation     = true
    }
    bu2 = {
      cidr            = "10.2.0.0/16"
      public_subnets  = ["10.2.10.0/24", "10.2.110.0/24"]
      private_subnets = ["10.2.52.0/24", "10.2.152.0/24"]
      workstation     = false
    }
  }
  description = "The spoke VPCs with BU specific applications."
}

variable "sharedVPCs" {
  type = map(object({
    cidr                     = string
    public_subnets           = list(any)
    private_subnets          = list(any)
    volterra_inside_subnet   = string
    volterra_workload_subnet = string
  }))
  default = {
    hub = {
      cidr                     = "100.64.0.0/20"
      public_subnets           = ["100.64.0.0/24", "100.64.1.0/24", "100.64.2.0/24"]
      private_subnets          = ["100.64.3.0/24", "100.64.4.0/24", "100.64.5.0/24"]
      volterra_inside_subnet   = "100.64.6.0/24"
      volterra_workload_subnet = "100.64.7.0/24"
    }
  }
  description = "The shared VPCs with common services like security, firewall, load balancing, and more."
}

variable "awsNumWebservers" {
  type        = number
  default     = 1
  description = "The number of webserver instances to launch in each business unit spoke."
}
