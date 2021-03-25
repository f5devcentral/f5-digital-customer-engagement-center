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
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name  = "${var.projectPrefix}-tgw-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#BU1 TGW Routing table 
resource "aws_ec2_transit_gateway_route_table" "rtTgwBu1" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name  = "${var.projectPrefix}-rtTgwBu1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}
resource "aws_ec2_transit_gateway_route" "rtTgwBu1DefaultRoute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBu1TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu1.id
}
resource "aws_ec2_transit_gateway_route" "rtTgwBu1SharedRoute" {
  destination_cidr_block         = "100.64.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitBu1TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu1.id
}

#BU2 TGW Routing table 
resource "aws_ec2_transit_gateway_route_table" "rtTgwBu2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name  = "${var.projectPrefix}-rtTgwBu2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}
resource "aws_ec2_transit_gateway_route" "rtTgwBu2DefaultRoute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBu2TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu2.id
}
resource "aws_ec2_transit_gateway_route" "rtTgwBu2SharedRoute" {
  destination_cidr_block         = "100.64.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitBu2TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu2.id
}

#Acme TGW Routing table 
resource "aws_ec2_transit_gateway_route_table" "rtTgwAcme" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name  = "${var.projectPrefix}-rtTgwAcme-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}
resource "aws_ec2_transit_gateway_route" "rtTgwAcmeDefaultRoute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcAcmeTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwAcme.id
}
resource "aws_ec2_transit_gateway_route" "rtTgwAcmeSharedRoute" {
  destination_cidr_block         = "100.64.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitAcmeTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwAcme.id
}

################### TGW - attachments #######
# see https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-appliance-scenario.html
resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBu1TgwAttachment" {
  subnet_ids                                      = module.vpcBu1.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcBu1.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcBu1TgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBu2TgwAttachment" {
  subnet_ids                                      = module.vpcBu2.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcBu2.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcBu2TgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAcmeTgwAttachment" {
  subnet_ids                                      = module.vpcAcme.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcAcme.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcAcmeTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu1TgwAttachment" {
  subnet_ids                                      = module.vpcTransitBu1.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcTransitBu1.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitBu1TgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu2TgwAttachment" {
  subnet_ids                                      = module.vpcTransitBu2.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcTransitBu2.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitBu2TgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitAcmeTgwAttachment" {
  subnet_ids                                      = module.vpcTransitAcme.intra_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpcTransitAcme.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitAcmeTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcBu1RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBu1TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu1.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcBu2RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBu2TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu2.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcAcmeRtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcAcmeTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwAcme.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcTransitBu1RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitBu1TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu1.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcTransitBu2RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitBu2TgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwBu2.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpcTransitAcmeRtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcTransitAcmeTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwAcme.id
}

##################################################################### Transit gateway #############################################################

##################################################################### VPC's #############################################################



module "vpcBu1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu1-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24"]
  private_subnets                    = ["10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcBu1-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu1SharedAddressSpace" {
  route_table_id         = module.vpcBu1.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  depends_on             = [aws_ec2_transit_gateway.tgw]
}

module "vpcBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24"]
  private_subnets                    = ["10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu2SharedAddressSpace" {
  route_table_id         = module.vpcBu2.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  depends_on             = [aws_ec2_transit_gateway.tgw]
}

module "vpcAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24"]
  private_subnets                    = ["10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcAcmeSharedAddressSpace" {
  route_table_id         = module.vpcAcme.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  depends_on             = [aws_ec2_transit_gateway.tgw]
}

module "vpcTransitBu1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitBu1-${random_id.buildSuffix.hex}"

  cidr = "100.64.0.0/21"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["100.64.0.0/24", "100.64.1.0/24"]
  private_subnets                    = ["100.64.2.0/24", "100.64.3.0/24"]
  intra_subnets                      = ["100.64.4.0/24", "100.64.5.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcTransitBu1-${random_id.buildSuffix.hex}"
    }

}

module "vpcTransitBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"

  cidr = "100.64.8.0/21"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["100.64.8.0/24", "100.64.9.0/24"]
  private_subnets                    = ["100.64.10.0/24", "100.64.11.0/24"]
  intra_subnets                      = ["100.64.12.0/24", "100.64.13.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"
    }

}

module "vpcTransitAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitAcme-${random_id.buildSuffix.hex}"

  cidr = "100.64.16.0/21"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["100.64.16.0/24", "100.64.17.0/24"]
  private_subnets                    = ["100.64.18.0/24", "100.64.19.0/24"]
  intra_subnets                      = ["100.64.20.0/24", "100.64.21.0/24"]
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcTransitBu2-${random_id.buildSuffix.hex}"
    }

}


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
      subnetId = module.vpcBu1.private_subnets[0]
    }

    vpcBu2App1 = {
      vpcId    = module.vpcBu2.vpc_id
      subnetId = module.vpcBu2.private_subnets[0]
    }

    vpcAcmeApp1 = {
      vpcId    = module.vpcAcme.vpc_id
      subnetId = module.vpcAcme.private_subnets[0]
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