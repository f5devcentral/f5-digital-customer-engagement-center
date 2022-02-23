variable prefix {
  description = "Prefix for resources created by this module"
  type        = string
}

variable f5_username {
  description = "The admin username of the F5 Bigip that will be deployed"
  default     = "bigipuser"
}
variable f5_password {
  description = "The admin password of the F5 Bigip that will be deployed"
  default     = ""
}

variable resource_group_name {
  description = "The name of the resource group in which the resources will be created"
  type        = string
}
variable location {
  description = "The location in Azure in which the resources will be created"
  type        = string
}

variable mgmt_subnet_ids {
  description = "List of maps of subnetids of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id          = string
    public_ip          = bool
    private_ip_primary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
}

variable external_subnet_ids {
  description = "List of maps of subnetids of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id            = string
    public_ip            = bool
    private_ip_primary   = string
    private_ip_secondary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null, "private_ip_secondary" = null }]
}

variable internal_subnet_ids {
  description = "List of maps of subnetids of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id          = string
    public_ip          = bool
    private_ip_primary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
}


variable mgmt_securitygroup_ids {
  description = "List of network Security Groupids for management network "
  type        = list(string)
}

variable external_securitygroup_ids {
  description = "List of network Security Groupids for external network "
  type        = list(string)
  default     = []
}

variable internal_securitygroup_ids {
  description = "List of network Security Groupids for internal network "
  type        = list(string)
  default     = []
}

variable f5_instance_type {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_DS3_v2"
}

variable f5_image_name {
  type    = string
  default = "f5-bigip-virtual-edition-200m-best-hourly"
}
variable f5_version {
  type    = string
  default = "latest"
}

variable f5_product_name {
  type    = string
  default = "f5-big-ip-best"
}

variable storage_account_type {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}

variable enable_accelerated_networking {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = false
}

variable enable_ssh_key {
  type        = bool
  description = "(Optional) Enable ssh key authentication in Linux virtual Machine"
  default     = true
}

variable f5_ssh_publickey {
  description = "public key to be used for ssh access to the VM. e.g. c:/home/id_rsa.pub"
}

variable script_name {
  type    = string
  default = "f5_onboard"
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable DO_URL {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.21.0/f5-declarative-onboarding-1.21.0-3.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable AS3_URL {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.28.0/f5-appsvcs-3.28.0-3.noarch.rpm"
}

## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable TS_URL {
  description = "URL to download the BIG-IP Telemetry Streaming module"
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.20.0/f5-telemetry-1.20.0-3.noarch.rpm"
}

## Please check and update the latest FAST URL from https://github.com/F5Networks/f5-appsvcs-templates/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable FAST_URL {
  description = "URL to download the BIG-IP FAST module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.9.0/f5-appsvcs-templates-1.9.0-1.noarch.rpm"
}

## Please check and update the latest Failover Extension URL from https://github.com/F5Networks/f5-cloud-failover-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable CFE_URL {
  description = "URL to download the BIG-IP Cloud Failover Extension module"
  type        = string
  default     = "https://github.com/F5Networks/f5-cloud-failover-extension/releases/download/v1.8.0/f5-cloud-failover-1.8.0-0.noarch.rpm"
}
## Please check and update the latest runtime init URL from https://github.com/F5Networks/f5-bigip-runtime-init/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable INIT_URL {
  description = "URL to download the BIG-IP runtime init"
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.2.1/dist/f5-bigip-runtime-init-1.2.1-1.gz.run"
}
variable libs_dir {
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
  default     = "/config/cloud/azure/node_modules"
  type        = string
}
variable onboard_log {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  default     = "/var/log/startup-script.log"
  type        = string
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

variable azure_secret_rg {
  description = "The name of the resource group in which the Azure Key Vault exists"
  type        = string
  default     = ""
}

variable az_key_vault_authentication {
  description = "Whether to use key vault to pass authentication"
  type        = bool
  default     = false
}

variable azure_keyvault_name {
  description = "The name of the Azure Key Vault to use"
  type        = string
  default     = ""
}

variable azure_keyvault_secret_name {
  description = "The name of the Azure Key Vault secret containing the password"
  type        = string
  default     = ""
}

variable custom_user_data {
  description = "Provide a custom bash script or cloud-init script the BIG-IP will run on creation"
  type        = string
  default     = null
}
