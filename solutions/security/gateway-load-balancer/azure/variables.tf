
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
variable "dns_server" {
  type        = string
  default     = "8.8.8.8"
  description = "Leave the default DNS server the BIG-IP uses, or replace the default DNS server with the one you want to use"
}
variable "ntp_server" {
  type        = string
  default     = "0.us.pool.ntp.org"
  description = "Leave the default NTP server the BIG-IP uses, or replace the default NTP server with the one you want to use"
}
variable "timezone" {
  type        = string
  default     = "UTC"
  description = "If you would like to change the time zone the BIG-IP uses, enter the time zone you want to use. This is based on the tz database found in /usr/share/zoneinfo (see the full list [here](https://github.com/F5Networks/f5-azure-arm-templates/blob/master/azure-timezone-list.md)). Example values: UTC, US/Pacific, US/Eastern, Europe/London or Asia/Singapore."
}
variable "lb_rules_ports" {
  type        = list(any)
  default     = ["22", "80", "443"]
  description = "List of ports to be opened by LB rules on public-facing LB."
}
variable "availability_zone" {
  type        = string
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  default     = 1
}
variable "availabilityZones_public_ip" {
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone."
  type        = string
  default     = "Zone-Redundant"
}
variable "DO_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.31.0/f5-declarative-onboarding-1.31.0-6.noarch.rpm"
  description = "URL to download the BIG-IP Declarative Onboarding module"
}
variable "AS3_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.38.0/f5-appsvcs-3.38.0-4.noarch.rpm"
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
}
variable "TS_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.30.0/f5-telemetry-1.30.0-1.noarch.rpm"
  description = "URL to download the BIG-IP Telemetry Streaming module"
}
variable "FAST_URL" {
  description = "URL to download the BIG-IP FAST module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.19.0/f5-appsvcs-templates-1.19.0-1.noarch.rpm"
}
variable "INIT_URL" {
  description = "URL to download the BIG-IP runtime init"
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.1/dist/f5-bigip-runtime-init-1.5.1-1.gz.run"
}
variable "libs_dir" {
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
  default     = "/config/cloud/azure/node_modules"
  type        = string
}
variable "bigIqHost" {
  type        = string
  default     = ""
  description = "This is the BIG-IQ License Manager host name or IP address"
}
variable "bigIqUsername" {
  type        = string
  default     = "azureuser"
  description = "Admin name for BIG-IQ"
}
variable "bigIqPassword" {
  type        = string
  default     = "Default12345!"
  description = "Admin Password for BIG-IQ"
}
variable "bigIqLicenseType" {
  type        = string
  default     = "licensePool"
  description = "BIG-IQ license type"
}
variable "bigIqLicensePool" {
  type        = string
  default     = ""
  description = "BIG-IQ license pool name"
}
variable "bigIqSkuKeyword1" {
  type        = string
  default     = "key1"
  description = "BIG-IQ license SKU keyword 1"
}
variable "bigIqSkuKeyword2" {
  type        = string
  default     = "key2"
  description = "BIG-IQ license SKU keyword 2"
}
variable "bigIqUnitOfMeasure" {
  type        = string
  default     = "hourly"
  description = "BIG-IQ license unit of measure"
}
variable "bigIqHypervisor" {
  type        = string
  default     = "azure"
  description = "BIG-IQ hypervisor"
}
variable "owner" {
  type        = string
  default     = null
  description = "This is a tag used for object creation. Example is last name."
}
