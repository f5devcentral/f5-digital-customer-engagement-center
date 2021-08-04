data "aws_availability_zones" "available" {
  state = "available"
}
##################################################################### Locals #############################################################
locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]
}



##################################################################### Locals #############################################################

##################################################################### Transit gateway #############################################################
resource "aws_ec2_transit_gateway" "tgwVolterra" {
  description = "Transit Gateway"
  tags = {
    Name  = "${var.projectPrefix}-tgwVolterra-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_ec2_transit_gateway" "tgwBu1" {
  description                     = "Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name  = "${var.projectPrefix}-tgwBu1-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_ec2_transit_gateway" "tgwBu2" {
  description                     = "Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name  = "${var.projectPrefix}-tgwBu2-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_ec2_transit_gateway" "tgwAcme" {
  description                     = "Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name  = "${var.projectPrefix}-tgwAcme-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

################### TGW - attachments #######
resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu1TgwAttachment" {
  subnet_ids         = module.vpcTransitBu1.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgwVolterra.id
  vpc_id             = module.vpcTransitBu1.vpc_id
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitBu1TgwAttachment-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu2TgwAttachment" {
  subnet_ids         = module.vpcTransitBu2.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgwVolterra.id
  vpc_id             = module.vpcTransitBu2.vpc_id
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitBu2TgwAttachment-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitAcmeTgwAttachment" {
  subnet_ids         = module.vpcTransitAcme.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgwVolterra.id
  vpc_id             = module.vpcTransitAcme.vpc_id
  tags = {
    Name  = "${var.projectPrefix}-vpcTransitAcmeTgwAttachment-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
}

##################################################################### Transit gateway #############################################################

##################################################################### VPC's #############################################################
#transit VPC's

module "vpcTransitBu1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitBu1-${var.buildSuffix}"

  cidr = "100.64.0.0/20"

  azs             = [local.awsAz1, local.awsAz2, local.awsAz3]
  public_subnets  = ["100.64.0.0/24", "100.64.1.0/24", "100.64.3.0/24"]
  private_subnets = ["100.64.4.0/24", "100.64.5.0/24", "100.64.6.0/24"]
  #intra_subnets        = ["100.64.7.0/24", "100.64.8.0/24", "100.64.9.0/24"]
  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcTransitBu1-${var.buildSuffix}"
  }

}

resource "aws_subnet" "bu1VoltSliAz1" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.10.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltSliAz2" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.11.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltSliAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltSliAz3" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.12.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltSliAz3-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltWorkloadAz1" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.7.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltWorkloadAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltWorkloadAz2" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.8.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltWorkloadAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltWorkloadAz3" {
  vpc_id            = module.vpcTransitBu1.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.9.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltWorkloadAz3-${var.buildSuffix}"
  }
}

resource "aws_route" "vpcTransitBu1SharedAddressSpace" {
  route_table_id         = module.vpcTransitBu1.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwVolterra.id
  depends_on             = [aws_ec2_transit_gateway.tgwVolterra]
}

module "vpcTransitBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitBu2-${var.buildSuffix}"

  cidr = "100.64.16.0/20"

  azs             = [local.awsAz1, local.awsAz2, local.awsAz3]
  public_subnets  = ["100.64.16.0/24", "100.64.17.0/24", "100.64.18.0/24"]
  private_subnets = ["100.64.19.0/24", "100.64.20.0/24", "100.64.21.0/24"]
  #  intra_subnets   = ["100.64.22.0/24", "100.64.23.0/24", "100.64.24.0/24"]

  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcTransitBu2-${var.buildSuffix}"
  }

}

resource "aws_subnet" "bu2VoltSliAz1" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.25.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltSliAz2" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.26.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltSliAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltSliAz3" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.27.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltSliAz3-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltWorkloadAz1" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.22.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltWorkloadAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltWorkloadAz2" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.23.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltWorkloadAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltWorkloadAz3" {
  vpc_id            = module.vpcTransitBu2.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.24.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltWorkloadAz3-${var.buildSuffix}"
  }
}
resource "aws_route" "vpcTransitBu2SharedAddressSpace" {
  route_table_id         = module.vpcTransitBu2.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwVolterra.id
  depends_on             = [aws_ec2_transit_gateway.tgwVolterra]
}

module "vpcTransitAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcTransitAcme-${var.buildSuffix}"

  cidr = "100.64.32.0/20"

  azs             = [local.awsAz1, local.awsAz2, local.awsAz3]
  public_subnets  = ["100.64.32.0/24", "100.64.33.0/24", "100.64.34.0/24"]
  private_subnets = ["100.64.35.0/24", "100.64.36.0/24", "100.64.37.0/24"]
  #  intra_subnets   = ["100.64.38.0/24", "100.64.39.0/24", "100.64.40.0/24"]

  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcTransitAcme-${var.buildSuffix}"
  }

}

resource "aws_route" "vpcTransitAcmeSharedAddressSpace" {
  route_table_id         = module.vpcTransitAcme.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwVolterra.id
  depends_on             = [aws_ec2_transit_gateway.tgwVolterra]
}

resource "aws_subnet" "acmeVoltSliAz1" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.42.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltSliAz2" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.43.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltSliAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltSliAz3" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.44.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltSliAz3-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltWorkloadAz1" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "100.64.38.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltWorkloadAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltWorkloadAz2" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz2
  cidr_block        = "100.64.39.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltWorkloadAz2-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltWorkloadAz3" {
  vpc_id            = module.vpcTransitAcme.vpc_id
  availability_zone = local.awsAz3
  cidr_block        = "100.64.40.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltWorkloadAz3-${var.buildSuffix}"
  }
}
######################################################BU vpc's########################################
module "vpcBu1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu1-${var.buildSuffix}"

  cidr = "10.1.0.0/16"

  azs            = [local.awsAz1, local.awsAz2]
  public_subnets = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]

  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcBu1-${var.buildSuffix}"
  }

}

resource "aws_route" "vpcBu1SharedAddressSpace" {
  route_table_id         = module.vpcBu1.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu1.id
  depends_on             = [aws_ec2_transit_gateway.tgwBu1, volterra_tf_params_action.applyBu1]
}


module "vpcBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu2-${var.buildSuffix}"

  cidr = "10.1.0.0/16"

  azs            = [local.awsAz1, local.awsAz2]
  public_subnets = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]

  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcBu2-${var.buildSuffix}"
  }

}

resource "aws_route" "vpcBu2SharedAddressSpace" {
  route_table_id         = module.vpcBu2.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu2.id
  depends_on             = [aws_ec2_transit_gateway.tgwBu2, volterra_tf_params_action.applyBu2]
}
module "vpcAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcAcme-${var.buildSuffix}"

  cidr = "10.1.0.0/16"

  azs            = [local.awsAz1, local.awsAz2]
  public_subnets = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets  = ["10.1.52.0/24", "10.1.152.0/24"]

  enable_dns_hostnames = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpcAcme-${var.buildSuffix}"
  }

}

resource "aws_route" "vpcAcmeSharedAddressSpace" {
  route_table_id         = module.vpcAcme.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgwAcme.id
  depends_on             = [aws_ec2_transit_gateway.tgwAcme, volterra_tf_params_action.applyAcme]
}

#Compute

resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${var.buildSuffix}"
  public_key = var.ssh_key
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
    vpcTransitBu1Jumphost = {
      vpcId    = module.vpcTransitBu1.vpc_id
      subnetId = module.vpcTransitBu1.public_subnets[0]
    }

    vpcTransitBu2Jumphost = {
      vpcId    = module.vpcTransitBu2.vpc_id
      subnetId = module.vpcTransitBu2.public_subnets[0]
    }

    vpcTransitAcmeJumphost = {
      vpcId    = module.vpcTransitAcme.vpc_id
      subnetId = module.vpcTransitAcme.public_subnets[0]
    }
  }

  webservers = {
    vpcBu1App1 = {
      vpcId    = module.vpcBu1.vpc_id
      subnetId = module.vpcBu1.public_subnets[0]
    }

    vpcBu2App1 = {
      vpcId    = module.vpcBu2.vpc_id
      subnetId = module.vpcBu2.public_subnets[0]
    }

    vpcAcmeApp1 = {
      vpcId    = module.vpcAcme.vpc_id
      subnetId = module.vpcAcme.public_subnets[0]
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
  associateEIP  = false
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
