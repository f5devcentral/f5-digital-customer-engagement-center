variable prefix {
  description = "Prefix for resources created by this module"
  type        = string
  //default     = "tf-aws-bigip"
}

variable f5_username {
  description = "The admin username of the F5 Bigip that will be deployed"
  default     = "bigipuser"
}

variable f5_password {
  description = "Password of the F5 Bigip that will be deployed"
  default     = ""
}

variable f5_ami_search_name {
  description = "BIG-IP AMI name to search for"
  type        = string
  //default     = "F5 BIGIP-*"
  default = "F5 BIGIP-16* PAYG-Best 200Mbps*"
  #default = "F5 Networks BIGIP-14.0.1-0.0.14 PAYG - Best 1Gbps - 20190817094829-929ca0d8-c2d7-4068-8f9a-eb75a677afed-ami-047292a9177e2e328.4"
}

variable f5_instance_count {
  description = "Number of BIG-IPs to deploy"
  type        = number
  default     = 1
}

variable ec2_instance_type {
  description = "AWS EC2 instance type"
  type        = string
  default     = "m5.xlarge"
  #default     = "c4.xlarge"
}

variable ec2_key_name {
  description = "AWS EC2 Key name for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  //default     = "tf-demo-key"
}

variable mgmt_eip {
  description = "Enable an Elastic IP address on the management interface"
  type        = bool
  default     = true
}

variable aws_secretmanager_auth {
  description = "Whether to use secret manager to pass authentication"
  type        = bool
  default     = false
}

variable aws_secretmanager_secret_id {
  description = "AWS Secret Manager Secret ID that stores the BIG-IP password"
  type        = string
  default     = null
}

variable aws_iam_instance_profile {
  description = "aws_iam_instance_profile"
  type        = string
  default     = null
}

variable mgmt_subnet_ids {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id          = string
    public_ip          = bool
    private_ip_primary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
}

variable external_subnet_ids {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id            = string
    public_ip            = bool
    private_ip_primary   = string
    private_ip_secondary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null, "private_ip_secondary" = null }]
}

variable internal_subnet_ids {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type = list(object({
    subnet_id          = string
    public_ip          = bool
    private_ip_primary = string
  }))
  default = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
}

variable internal_source_dest_check {
  description = "Disable source/dest check on Internal interface to allow inline routing for backends"
  default     = true
}

variable external_source_dest_check {
  description = "Disable source/dest check on External interface to allow inline routing for backends"
  default     = true
}

variable mgmt_securitygroup_ids {
  description = "The Network Security Group ids for management network "
  type        = list(string)
}

variable external_securitygroup_ids {
  description = "The Network Security Group ids for external network "
  type        = list(string)
  default     = []
}

variable internal_securitygroup_ids {
  description = "The Network Security Group ids for internal network "
  type        = list(string)
  default     = []
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable DO_URL {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.18.0/f5-declarative-onboarding-1.18.0-4.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable AS3_URL {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.25.0/f5-appsvcs-3.25.0-3.noarch.rpm"
}

## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable TS_URL {
  description = "URL to download the BIG-IP Telemetry Streaming module"
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.17.0/f5-telemetry-1.17.0-4.noarch.rpm"
}

## Please check and update the latest Failover Extension URL from https://github.com/f5devcentral/f5-cloud-failover-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable CFE_URL {
  description = "URL to download the BIG-IP Cloud Failover Extension module"
  type        = string
  default     = "https://github.com/F5Networks/f5-cloud-failover-extension/releases/download/v1.7.1/f5-cloud-failover-1.7.1-1.noarch.rpm"
}

## Please check and update the latest FAST URL from https://github.com/F5Networks/f5-appsvcs-templates/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable FAST_URL {
  description = "URL to download the BIG-IP FAST module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.6.1/f5-appsvcs-templates-1.6.1-1.noarch.rpm"
}
## Please check and update the latest runtime init URL from https://github.com/F5Networks/f5-bigip-runtime-init/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable INIT_URL {
  description = "URL to download the BIG-IP runtime init"
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.2.0/dist/f5-bigip-runtime-init-1.2.0-1.gz.run"
}
variable libs_dir {
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
  type        = string
  default     = "/config/cloud/aws/node_modules"
}

variable onboard_log {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  type        = string
  default     = "/var/log/startup-script.log"
}

variable custom_user_data {
  description = "Provide a custom bash script or cloud-init script the BIG-IP will run on creation"
  type        = string
  default     = null
}
