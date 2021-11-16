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
  type        = string
  default     = ""
  description = <<EOD
An optional SSH key to add to nodes.
EOD
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

variable "volterraVirtualSite" {
  type        = string
  default     = null
  description = <<EOD
The name of the Volterra virtual site that will receive LB registrations.
EOD
}

variable "domain_name" {
  type        = string
  description = <<EOD
The DNS domain name that will be used as common parent generated DNS name of
loadbalancers.
EOD
  default     = "shared.acme.com"
}

variable "publicDomain" {
  type        = string
  description = "The DNS domain name that will be used as common parent generated DNS name of loadbalancers"
  default     = ""
}


variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional list of labels to apply to AWS resources.
EOD
}

variable "externalWebserverBu1" {
  description = "Controls the deployment of an external webserver group"
  type = object(
    {
      deploy            = bool
      associatePublicIp = bool
      desiredCapacity   = number
    }
  )
  default = {
    deploy            = true
    associatePublicIp = false
    desiredCapacity   = 1
  }
}
variable "awsLabels" {
  type        = map(string)
  default     = {}
  description = "An optional list of labels to apply to AWS resources."
}
variable "vpcData" {
  type = object({
    cidr            = string
    public_subnets  = list(any)
    private_subnets = list(any)
    workstation     = bool
    sli_cidr_block  = string
    workload_cidr_block = string
  })
  default = {
      cidr            = "100.64.0.0/16"
      public_subnets  = ["100.64.10.0/24", "100.64.110.0/24"]
      private_subnets = ["100.64.52.0/24", "100.64.152.0/24"]
      sli_cidr_block  = "100.64.20.0/24"
      workload_cidr_block  = "100.64.30.0/24"
      workstation     = true
  }
  description = "Variables to build the VPC with"
}

variable "outside_cidr" {
  type        = string
  default     = "100.64.96.0/20"
  description = "The CIDR to assign to shared outside VPC. Default is '100.64.96.0/20'."
}

variable "awsNumWebservers" {
  type        = number
  default     = 1
  description = "The number of webserver instances to launch in each business unit spoke."
}

variable "bigipInstanceCount" {
  type        = number
  default     = 1
  description = "Number of BIG-IP's in the GWLB group"
}
variable "allowedMgmtIps" {
  default = ["0.0.0.0/0"]
  description = "Ip addresses that can access the BIG-IP mgmt console"
}
