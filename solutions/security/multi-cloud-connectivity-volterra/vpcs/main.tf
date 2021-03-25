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
  privateDnsAddress = module.bigip.*.mgmtPrivateIP[0][0]
}



##################################################################### Locals #############################################################

##################################################################### Transit gateway #############################################################
#resource "aws_ec2_transit_gateway" "tgwVolterra" {
#  description                     = "Transit Gateway"
#  tags = {
#    Name  = "${var.projectPrefix}-tgw-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#}
#
#################### TGW - attachments #######
## see https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-appliance-scenario.html
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu1TgwAttachment" {
#  subnet_ids                                      = module.vpcTransitBu1.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwVolterra.id
#  vpc_id                                          = module.vpcTransitBu1.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcTransitBu1TgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
#}
#
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitBu2TgwAttachment" {
#  subnet_ids                                      = module.vpcTransitBu2.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwVolterra.id
#  vpc_id                                          = module.vpcTransitBu2.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcTransitBu2TgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
#}
#
#resource "aws_ec2_transit_gateway_vpc_attachment" "vpcTransitAcmeTgwAttachment" {
#  subnet_ids                                      = module.vpcTransitAcme.intra_subnets
#  transit_gateway_id                              = aws_ec2_transit_gateway.tgwVolterra.id
#  vpc_id                                          = module.vpcTransitAcme.vpc_id
#  tags = {
#    Name  = "${var.projectPrefix}-vpcTransitAcmeTgwAttachment-${random_id.buildSuffix.hex}"
#    Owner = var.resourceOwner
#  }
#  depends_on = [aws_ec2_transit_gateway.tgwVolterra]
#}


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

  enable_dns_hostnames = true
  tags                               = { 
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-vpcBu1-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu1SharedAddressSpace" {
  route_table_id         = module.vpcBu1.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-06de4bb2f58c8840f"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu1.id
#  depends_on             = [aws_ec2_transit_gateway.tgwBu1]
}

resource "aws_route53_resolver_rule" "route53RuleBu1" {
  name                 = "route53RuleBu1-${random_id.buildSuffix.hex}"
  domain_name          = "shared.acme.com"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.resolverAcmeDns.id

  target_ip {
    ip = local.privateDnsAddress
  }

  tags = {
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-route53RuleBu1-${random_id.buildSuffix.hex}"
  }
}

resource "aws_route53_resolver_rule_association" "ruleAssociationBu1" {
  resolver_rule_id = aws_route53_resolver_rule.route53RuleBu1.id
  vpc_id           = module.vpcBu1.vpc_id
}

module "vpcBu2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]

  enable_dns_hostnames = true
  tags                               = { 
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-vpcBu2-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcBu2SharedAddressSpace" {
  route_table_id         = module.vpcBu2.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-021767b0ec065dc7c"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwBu2.id
#  depends_on             = [aws_ec2_transit_gateway.tgwBu2]
}

resource "aws_route53_resolver_rule" "route53RuleBu2" {
  name                 = "route53RuleBu2-${random_id.buildSuffix.hex}"
  domain_name          = "shared.acme.com"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.resolverAcmeDns.id

  target_ip {
    ip = local.privateDnsAddress
  }

  tags = {
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-route53RuleBu2-${random_id.buildSuffix.hex}"
  }
}

resource "aws_route53_resolver_rule_association" "ruleAssociationBu2" {
  resolver_rule_id = aws_route53_resolver_rule.route53RuleBu2.id
  vpc_id           = module.vpcBu2.vpc_id
}

module "vpcAcme" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["10.1.10.0/24", "10.1.110.0/24", "10.1.20.0/24", "10.1.120.0/24"]
  intra_subnets                      = ["10.1.52.0/24", "10.1.152.0/24"]

  enable_dns_hostnames = true
  tags                               = { 
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-vpcAcme-${random_id.buildSuffix.hex}"
    }

}

resource "aws_route" "vpcAcmeSharedAddressSpace" {
  route_table_id         = module.vpcAcme.public_route_table_ids[0]
  destination_cidr_block = "100.64.0.0/16"
  transit_gateway_id     = "tgw-04264a2e14b4b70be"
#  transit_gateway_id     = aws_ec2_transit_gateway.tgwAcme.id
#  depends_on             = [aws_ec2_transit_gateway.tgwAcme]
}

resource "aws_route53_resolver_rule" "route53RuleAcme" {
  name                 = "route53RuleAcme-${random_id.buildSuffix.hex}"
  domain_name          = "shared.acme.com"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.resolverAcmeDns.id

  target_ip {
    ip = local.privateDnsAddress
  }

  tags = {
    resourceOwner = var.resourceOwner
    Name       = "${var.projectPrefix}-route53RuleAcme-${random_id.buildSuffix.hex}"
  }
}

resource "aws_route53_resolver_rule_association" "ruleAssociationAcme" {
  resolver_rule_id = aws_route53_resolver_rule.route53RuleAcme.id
  vpc_id           = module.vpcAcme.vpc_id
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
      subnetId = module.vpcBu1.public_subnets[1]
    }

    vpcBu2Jumphost = {
      vpcId    = module.vpcBu2.vpc_id
      subnetId = module.vpcBu2.public_subnets[1]
    }

    vpcAcmeJumphost = {
      vpcId    = module.vpcAcme.vpc_id
      subnetId = module.vpcAcme.public_subnets[1]
    }
    vpcTransitBu1Jumphost = {
      vpcId    = "vpc-04013515ccf2a64fa"
      subnetId = "subnet-0783618b49353c925"
    }
    vpcTransitBu2Jumphost = {
      vpcId    = "vpc-058df8fb7e2939db7"
      subnetId = "subnet-0f1361d2640e85acd"
    }
    vpcTransitAcmeJumphost = {
      vpcId    = "vpc-090de9b1a73a8f711"
      subnetId = "subnet-0d5dbbc7bde142fd4"
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
