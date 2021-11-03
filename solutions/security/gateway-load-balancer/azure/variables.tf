
#Azure variables
variable "rg_name" {default = "my-demo-resource-group"}
#BIG-IP variables
variable "instance_count" {
  default = "2"
  description = "Number of F5 BIG-IP appliances to deploy behind Gateway Load Balancer"
}
variable "instance_count_app" {
  default = "1"
  description = "Number of demo web app servers to deploy behind public Load Balancer"
  }
variable "prefix" {default = "mydemo"}
variable "uname" {default = "azureuser"}
variable "upassword" {default = "DefaultPass12345!"}
variable "location" {default = "East US 2"}
variable "f5_version" {
  default = "latest"
}
#Network variables
variable "network_cidr" {default = "10.0.0.0/16"}
variable "network_cidr_consumer" {default = "192.168.0.0/16"}
#variable "external_subnet_gw" {default = "10.0.2.1"}
#variable "mgmt_subnet_gw" {default = "10.0.1.1"}
variable "app1_subnet_prefix" {default = "192.168.1.0/24"}
variable "provider_vnet_subnets_map" {
    type = map
    default = {
      mgmt = {
        name                      = "mgmt"
        address_prefixes          = ["10.0.1.0/24"]
      }
      external = {
        name                      = "external"
        address_prefixes          = ["10.0.2.0/24"]

      }
      internal = {
        name                      = "internal"
        address_prefixes          = ["10.0.3.0/24"]
      }
    }
  }

variable "AllowedIPs" {
  description = "List of source address prefixes. Tags may not be used."
  type        = list
  default     = ["0.0.0.0/0"]
}
variable "lb_rules_ports" {
  description = "List of ports to be opened by LB rules on public-facing LB."
  type        = list
  default     = ["22", "80", "443"]
}
variable "nsg_rules_ports_mgmt" {
    type = map
    default = {
      allow_ssh = {
        name                      = "allow_ssh"
        priority                  = 200
        protocol                  = "Tcp"
        destination_port          = "22"
      }
      allow_https = {
        name                      = "allow_https"
        priority                  = 202
        protocol                  = "Tcp"
        destination_port          = "443"
      }
    }
  }

variable "nsg_rules_ports_app1Subnet" {
    type = map
    default = {
      allow_ssh = {
        name                      = "allow_ssh"
        priority                  = 200
        protocol                  = "Tcp"
        destination_port          = "22"
      }
      allow_http = {
        name                      = "allow_http"
        priority                  = 201
        protocol                  = "Tcp"
        destination_port          = "80"
      }
      allow_https = {
        name                      = "allow_https"
        priority                  = 202
        protocol                  = "Tcp"
        destination_port          = "443"
      }
    }
  }

variable "nsg_rules_ports_external" {
    type = map
    default = {
      allow_all = {
        name                      = "allow_all"
        priority                  = 200
        protocol                  = "Tcp"
        destination_port          = "*"
      }
    }
  }
variable availabilityZones {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list
  default     = [1]
}

variable availabilityZones_public_ip {
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone."
  type        = string
  default     = "Zone-Redundant"
}