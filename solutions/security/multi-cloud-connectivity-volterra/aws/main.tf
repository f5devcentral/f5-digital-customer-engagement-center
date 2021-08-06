############################ Locals ############################

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]
  volterra_common_labels = merge(var.labels, {
    platform = "aws"
  })
  volterra_common_annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}

############################ Locals for Business Units ############################

locals {
  business_units = {
    bu1 = {
      cidr           = "10.1.0.0/16"
      azs            = [local.awsAz1, local.awsAz2]
      public_subnets = ["10.1.10.0/24", "10.1.110.0/24"]
      intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]
    }
    bu2 = {
      cidr           = "10.1.0.0/16"
      azs            = [local.awsAz1, local.awsAz2]
      public_subnets = ["10.1.10.0/24", "10.1.110.0/24"]
      intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]
    }
    bu3 = {
      cidr           = "10.1.0.0/16"
      azs            = [local.awsAz1, local.awsAz2]
      public_subnets = ["10.1.10.0/24", "10.1.110.0/24"]
      intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]
    }
  }
}


############################ VPCs ############################

module "vpc" {
  for_each             = local.business_units
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 2.0"
  name                 = format("%s-vpc-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  cidr                 = each.value["cidr"]
  azs                  = each.value["azs"]
  public_subnets       = each.value["public_subnets"]
  intra_subnets        = each.value["intra_subnets"]
  enable_dns_hostnames = true
  tags = {
    Name      = format("%s-vpc-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ Workload Subnet ############################

# @JeffGiroux workaround route table association conflict
# - AWS VPC module creates subnets with RT associations
# - Volterra tries to create causes RT conflicts and fails site
# - Create additional subnets for sli and workload without RT for Volterra's use
resource "aws_subnet" "sli" {
  for_each          = local.business_units
  vpc_id            = module.vpc[each.key].vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.20.0/24"

  tags = {
    Name      = format("%s-site-local-inside-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

resource "aws_subnet" "workload" {
  for_each          = local.business_units
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

# Set locals
locals {
  jumphosts = {
    bu1 = {
      vpcId    = module.vpc["bu1"].vpc_id
      subnetId = module.vpc["bu1"].public_subnets[0]
      create   = true
    }
    bu2 = {
      vpcId    = module.vpc["bu2"].vpc_id
      subnetId = module.vpc["bu2"].public_subnets[0]
      create   = false
    }
    bu3 = {
      vpcId    = module.vpc["bu3"].vpc_id
      subnetId = module.vpc["bu3"].public_subnets[0]
      create   = false
    }
  }

  webservers = {
    bu1 = {
      vpcId    = module.vpc["bu1"].vpc_id
      subnetId = module.vpc["bu1"].intra_subnets[0]
    }
    bu2 = {
      vpcId    = module.vpc["bu2"].vpc_id
      subnetId = module.vpc["bu2"].intra_subnets[0]
    }
    bu3 = {
      vpcId    = module.vpc["bu3"].vpc_id
      subnetId = module.vpc["bu3"].intra_subnets[0]
    }
  }
}

# Jumphost Security Group
resource "aws_security_group" "jumphost" {
  for_each    = local.jumphosts
  name        = format("%s-sg-jumphost-%s", var.projectPrefix, var.buildSuffix)
  description = "Jumphost workstation security group"
  vpc_id      = each.value["vpcId"]

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
  for_each    = local.webservers
  name        = format("%s-sg-webservers-%s", var.projectPrefix, var.buildSuffix)
  description = "Webservers security group"
  vpc_id      = each.value["vpcId"]

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
  for_each      = { for k, v in local.jumphosts : k => v if v.create }
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value["vpcId"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value["subnetId"]
  securityGroup = aws_security_group.jumphost[each.key].id
  associateEIP  = true
}

# Create webserver instances
module "webserver" {
  for_each      = local.webservers
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value["vpcId"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value["subnetId"]
  securityGroup = aws_security_group.webserver[each.key].id
  associateEIP  = false
}
