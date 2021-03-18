provider "aws" {
  region = var.awsRegion
}

data "aws_availability_zones" "available" {
  state = "available"
}
##################################################################### Locals #############################################################
locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
}

##################################################################### Locals #############################################################

##################################################################### Transit gateway #############################################################
#resource "aws_ec2_transit_gateway" "tgwBu1" {
#  description                     = "Transit Gateway"
#  default_route_table_association = "disable"
#  default_route_table_propagation = "disable"
#  amazon_side_asn = 64521
#  tags = {
#    Name  = "${var.projectPrefix}-tgwBu1-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#}
#
#resource "aws_ec2_transit_gateway" "tgwBu2" {
#  description                     = "Transit Gateway"
#  default_route_table_association = "disable"
#  default_route_table_propagation = "disable"  
#  amazon_side_asn = 64522
#  tags = {
#    Name  = "${var.projectPrefix}-tgwBu2-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#}
#
#resource "aws_ec2_transit_gateway" "tgwAcme" {
#  description                     = "Transit Gateway"
#  default_route_table_association = "disable"
#  default_route_table_propagation = "disable"
#  amazon_side_asn = 64523
#  tags = {
#    Name  = "${var.projectPrefix}-tgwAcme-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#}

################### TGW - attachments #######
# see https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-appliance-scenario.html
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBu1TgwAttachment" {
#  subnet_ids                                      = module.vpcBu1.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwBu1.id
#  vpc_id                                          = module.vpcBu1.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcBu1TgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwBu1]
#}
#
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBu2TgwAttachment" {
#  subnet_ids                                      = module.vpcBu2.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwBu2.id
#  vpc_id                                          = module.vpcBu2.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcBu2TgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwBu2]
#}
#
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAcmeTgwAttachment" {
#  subnet_ids                                      = module.vpcAcme.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwAcme.id
#  vpc_id                                          = module.vpcAcme.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcAcmeTgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwAcme]
#}


##################################################################### Transit gateway #############################################################

##################################################################### VPC's #############################################################

module "vpcBu1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu1-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcBu1-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu1SharedAddressSpace" {
  route_table_id         = module.vpcBu1.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-06de4bb2f58c8840f"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu1.id
#  depends_on             = [aws_ec2_transit_gateway.tgwBu1]
}

module "vpcBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu2SharedAddressSpace" {
  route_table_id         = module.vpcBu2.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-021767b0ec065dc7c"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu2.id
#  depends_on             = [aws_ec2_transit_gateway.tgwBu2]
}

module "vpcAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcAcmeSharedAddressSpace" {
  route_table_id         = module.vpcAcme.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-04264a2e14b4b70be"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwAcme.id
#  depends_on             = [aws_ec2_transit_gateway.tgwAcme]
}

#module "vpcTransitBu1" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 2.0"
#
#  name = "${var.projectPrefix}-vpcTransitBu1-${random_id.buildSuffix.hex}"
#
#  cidr = "100.64.0.0/21"
#
#  azs                                = [local.awsAz1, local.awsAz2]
#  public_subnets                     = ["100.64.0.0/24", "100.64.1.0/24"]
#  private_subnets                    = ["100.64.2.0/24", "100.64.3.0/24"]
#  intra_subnets                      = ["100.64.4.0/24", "100.64.5.0/24"]
#  tags                               = { 
#    resourceOwner = var.resourceOwner
#    project       = "${var.projectPrefix}-vpcTransitBu1-${random_id.buildSuffix.hex}"
#    }
#
#}
#
#module "vpcTransitBu2" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 2.0"
#
#  name = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"
#
#  cidr = "100.64.8.0/21"
#
#  azs                                = [local.awsAz1, local.awsAz2]
#  public_subnets                     = ["100.64.8.0/24", "100.64.9.0/24"]
#  private_subnets                    = ["100.64.10.0/24", "100.64.11.0/24"]
#  intra_subnets                      = ["100.64.12.0/24", "100.64.13.0/24"]
#  tags                               = { 
#    resourceOwner = var.resourceOwner
#    project       = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"
#    }
#
#}
#
#module "vpcTransitAcme" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 2.0"
#
#  name = "${var.projectPrefix}-vpcTransitAcme-${random_id.buildSuffix.hex}"
#
#  cidr = "100.64.16.0/21"
#
#  azs                                = [local.awsAz1, local.awsAz2]
#  public_subnets                     = ["100.64.16.0/24", "100.64.17.0/24"]
#  private_subnets                    = ["100.64.18.0/24", "100.64.19.0/24"]
#  intra_subnets                      = ["100.64.20.0/24", "100.64.21.0/24"]
#  tags                               = { 
#    resourceOwner = var.resourceOwner
#    project       = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"
#    }
#
#}


#Compute 

resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${random_id.buildSuffix.hex}"
  public_key = var.sshPublicKey
}

#local for spinning up compute resources
locals {

  jumphosts = {

    vpcBu1Jumphost = {
      vpcId    = module.vpcBu1.vpc_id
      subnetId = module.vpcBu1.public_subnets[0]
    }

    vpcBu2Jumphost = {
      vpcId    = module.vpcBu2.vpc_id
      subnetId = module.vpcBu2.public_subnets[0]
    }

    vpcAcmeJumphost = {
      vpcId    = module.vpcAcme.vpc_id
      subnetId = module.vpcAcme.public_subnets[0]
    }
  }

  webservers = {
    vpcBu1App1 = {
      vpcId    = module.vpcBu1.vpc_id
      subnetId = module.vpcBu1.public_subnets[2]
    }

    vpcBu2App1 = {
      vpcId    = module.vpcBu2.vpc_id
      subnetId = module.vpcBu2.public_subnets[2]
    }

    vpcAcmeApp1 = {
      vpcId    = module.vpcAcme.vpc_id
      subnetId = module.vpcAcme.public_subnets[2]
    }

  }

}

resource "aws_security_group" "secGroupWorkstation" {
  for_each    = local.jumphosts
  name        = "secGroupWorkstation"
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
    Name  = "${var.projectPrefix}-secGroupWorkstation"
    Owner = var.resourceOwner
  }
}

resource "aws_security_group" "secGroupWebServers" {
  for_each    = local.webservers
  name        = "secGroupWebServers"
  description = "webservers  security group"
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
    Name  = "${var.projectPrefix}-secGroupwebservers"
    Owner = var.resourceOwner
  }
}

module "jumphost" {
  for_each      = local.jumphosts
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value["vpcId"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value["subnetId"]
  securityGroup = aws_security_group.secGroupWorkstation[each.key].id
  associateEIP  = true
}

module "webserver" {
  for_each      = local.webservers
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value["vpcId"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value["subnetId"]
  securityGroup = aws_security_group.secGroupWebServers[each.key].id
  associateEIP  = false
}