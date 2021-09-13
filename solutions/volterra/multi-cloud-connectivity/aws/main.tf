###########################Versions##########################
terraform {
  required_version = ">= 0.14.5"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.10"
    }
    aws = ">= 3"
  }
}

###########################providers##########################
provider "aws" {
  region = var.awsRegion
}

provider "volterra" {
  timeout = "90s"
}
############################ Locals ############################

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]


  awsCommonLabels = merge(var.awsLabels, {})
  volterraCommonLabels = merge(var.labels, {
    demo     = "multi-cloud-connectivity-volterra"
    owner    = var.resourceOwner
    prefix   = var.projectPrefix
    suffix   = var.buildSuffix
    platform = "aws"
  })
  volterraCommonAnnotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}

############################ VPCs ############################

module "vpc" {
  for_each             = var.awsBusinessUnits
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 2.0"
  name                 = format("%s-vpc-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  cidr                 = each.value["cidr"]
  azs                  = [local.awsAz1, local.awsAz2]
  public_subnets       = each.value["public_subnets"]
  private_subnets      = each.value["private_subnets"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags = merge(local.volterraCommonLabels, {
    bu = each.key
  })
}

############################ Workload Subnet ############################

# @JeffGiroux workaround route table association conflict
# - AWS VPC module creates subnets with RT associations
# - Volterra tries to create causes RT conflicts and fails site
# - Create additional subnets for sli and workload without RT for Volterra's use
resource "aws_subnet" "sli" {
  for_each          = var.awsBusinessUnits
  vpc_id            = module.vpc[each.key].vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.20.0/24"

  tags = {
    Name      = format("%s-site-local-inside-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

resource "aws_subnet" "workload" {
  for_each          = var.awsBusinessUnits
  vpc_id            = module.vpc[each.key].vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.30.0/24"

  tags = {
    Name      = format("%s-workload-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ Security Groups - Jumphost, Web Servers ############################

# SSH key
resource "aws_key_pair" "deployer" {
  key_name   = format("%s-sshkey-%s", var.projectPrefix, var.buildSuffix)
  public_key = var.ssh_key
}

# Jumphost Security Group
resource "aws_security_group" "jumphost" {
  for_each    = { for k, v in var.awsBusinessUnits : k => v if v.workstation }
  name        = format("%s-sg-jumphost-%s", var.projectPrefix, var.buildSuffix)
  description = "Jumphost workstation security group"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5800
    to_port     = 5800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = format("%s-sg-jumphost-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Webserver Security Group
resource "aws_security_group" "webserver" {
  for_each    = var.awsBusinessUnits
  name        = format("%s-sg-webservers-%s", var.projectPrefix, var.buildSuffix)
  description = "Webservers security group"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = format("%s-sg-webservers-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}


############################ Compute ############################

# Create jumphost instances
module "jumphost" {
  for_each      = { for k, v in var.awsBusinessUnits : k => v if v.workstation }
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = module.vpc[each.key].vpc_id
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = module.vpc[each.key].public_subnets[0]
  securityGroup = aws_security_group.jumphost[each.key].id
  associateEIP  = true
}

# Create webserver instances
module "webserver" {
  for_each = { for ws in setproduct(keys(var.awsBusinessUnits), range(0, var.awsNumWebservers)) : join("", ws) => {
    subnet        = module.vpc[ws[0]].private_subnets[0]
    vpc           = module.vpc[ws[0]].vpc_id
    securityGroup = aws_security_group.webserver[ws[0]].id
  } }
  source        = "../../../../modules/aws/terraform/backend/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value.vpc
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value.subnet
  securityGroup = each.value.securityGroup
  associateEIP  = false
}
