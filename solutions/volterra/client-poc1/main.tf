########################### Versions ##########################
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

########################### Providers ##########################
provider "aws" {
  region = var.awsRegion
}

provider "volterra" {
  timeout = "90s"
}

########################### Locals ##########################
resource "random_id" "buildSuffix" {
  byte_length = 2
}

locals {
  # Allow user to specify a build suffix, but fallback to random as needed.
  buildSuffix = coalesce(var.buildSuffix, random_id.buildSuffix.hex)
  volterraCommonLabels = {
    owner  = var.resourceOwner
    prefix = var.projectPrefix
    suffix = local.buildSuffix
  }
  volterraCommonAnnotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}

########################### AWS Availibility Zones ##########################

# Retrieve AZ values
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]
}

############################ AWS VPCs ############################

# Business Unit VPC(s) for clients and applications
module "vpc" {
  for_each             = var.awsBusinessUnits
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 2.0"
  name                 = format("%s-vpc-%s-%s", var.projectPrefix, each.key, local.buildSuffix)
  cidr                 = each.value["cidr"]
  azs                  = [local.awsAz1, local.awsAz2]
  public_subnets       = each.value["public_subnets"]
  private_subnets      = each.value["private_subnets"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    Name      = format("%s-vpc-%s-%s", var.projectPrefix, each.key, local.buildSuffix)
    Terraform = "true"
  }
}

# Shared VPC for shared services
module "vpcShared" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 2.0"
  name                 = format("%s-vpcShared-%s", var.projectPrefix, local.buildSuffix)
  cidr                 = var.sharedVPCs.hub.cidr
  azs                  = [local.awsAz1, local.awsAz2, local.awsAz3]
  public_subnets       = var.sharedVPCs.hub.public_subnets
  private_subnets      = var.sharedVPCs.hub.private_subnets
  enable_dns_hostnames = true

  tags = {
    Name      = format("%s-vpcShared-%s", var.projectPrefix, local.buildSuffix)
    Terraform = "true"
  }
}

############################ AWS Subnets ############################

# @JeffGiroux workaround route table association conflict
# - AWS VPC module creates subnets with RT associations
# - Volterra tries to create RT conflicts and fails due to existing RT
# - Fix = Create additional subnets for sli and workload without RT for Volterra's use
resource "aws_subnet" "sli" {
  vpc_id            = module.vpcShared.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = var.sharedVPCs.hub.volterra_inside_subnet
  tags = {
    Name      = format("%s-site-local-inside-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
}

resource "aws_subnet" "workload" {
  vpc_id            = module.vpcShared.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = var.sharedVPCs.hub.volterra_workload_subnet
  tags = {
    Name      = format("%s-workload-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
}

############################ AWS Transit Gateway ############################

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway"
  tags = {
    Name      = format("%s-tgw-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
}

# Transit Gateway Attachment for Spoke VPCs
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  for_each           = var.awsBusinessUnits
  subnet_ids         = module.vpc[each.key].private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.vpc[each.key].vpc_id
  tags = {
    Name      = format("%s-vpcAttach-%s-%s", var.resourceOwner, each.key, local.buildSuffix)
    Terraform = "true"
  }
  depends_on = [aws_ec2_transit_gateway.main]
}

# Transit Gateway Attachment for Shared VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "vpcShared" {
  subnet_ids         = module.vpcShared.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.vpcShared.vpc_id
  tags = {
    Name      = format("%s-vpcSharedAttach-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
  depends_on = [aws_ec2_transit_gateway.main]
}

############################ AWS Routes ############################

# Create Routes in each spoke VPC to reach shared VPC via TGW
# Flow = spoke VPC > TGW > shared VPC
resource "aws_route" "dstSharedVPC" {
  for_each               = var.awsBusinessUnits
  route_table_id         = module.vpc[each.key].public_route_table_ids[0]
  destination_cidr_block = module.vpcShared.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway.main]
}

# Create Routes in shared VPC to reach spoke VPCs via TGW
# Flow = shared VPC > TGW > spoke VPC
resource "aws_route" "dstSpokeVPC" {
  for_each               = var.awsBusinessUnits
  route_table_id         = module.vpcShared.public_route_table_ids[0]
  destination_cidr_block = module.vpc[each.key].vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on             = [aws_ec2_transit_gateway.main]
}

############################ AWS Security Groups - Jumphost, Web Servers ############################

# SSH key
resource "aws_key_pair" "deployer" {
  key_name   = format("%s-sshkey-%s", var.projectPrefix, local.buildSuffix)
  public_key = var.ssh_key
}

# Jumphost Security Group
resource "aws_security_group" "jumphost" {
  for_each    = { for k, v in var.awsBusinessUnits : k => v if v.workstation }
  name        = format("%s-sg-jumphost-%s", var.projectPrefix, local.buildSuffix)
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
    Name      = format("%s-sg-jumphost-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
}

# Webserver Security Group
resource "aws_security_group" "webserver" {
  for_each    = var.awsBusinessUnits
  name        = format("%s-sg-webservers-%s", var.projectPrefix, local.buildSuffix)
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
    Name      = format("%s-sg-webservers-%s", var.resourceOwner, local.buildSuffix)
    Terraform = "true"
  }
}

############################ AWS Compute ############################

# Create jumphost instances
module "jumphost" {
  for_each      = { for k, v in var.awsBusinessUnits : k => v if v.workstation }
  source        = "../../../modules/aws/terraform/workstation/"
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
  source        = "../../../modules/aws/terraform/backend/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value.vpc
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value.subnet
  securityGroup = each.value.securityGroup
  associateEIP  = false
}
