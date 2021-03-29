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

resource "aws_ec2_transit_gateway_route_table" "rtTgwIngress" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name  = "${var.projectPrefix}-rtTgwIngress-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}
resource "aws_ec2_transit_gateway_route" "ingressDefaultRoute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.securityVpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwIngress.id
}
resource "aws_ec2_transit_gateway_route_table" "rtTgwSecurity" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name  = "${var.projectPrefix}-rtTgwSecurity-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}
resource "aws_ec2_transit_gateway_route" "securityDefaultRoute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internetVpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwSecurity.id
}

#Route propogations
resource "aws_ec2_transit_gateway_route_table_propagation" "spoke10RtbAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke10VpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwSecurity.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke20RtbAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke20VpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwSecurity.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "internetRtbAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internetVpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwSecurity.id
}

################### TGW - Security VPC stuff #######
resource "aws_ec2_transit_gateway_vpc_attachment" "securityVpcTgwAttachment" {
  subnet_ids                                      = [aws_subnet.securityVpcSubnetTgwAttachmentAz1.id, aws_subnet.securityVpcSubnetTgwAttachmentAz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.gwlb-bigip.vpcs["vpcGwlb"]
  appliance_mode_support                          = enable # see https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-appliance-scenario.html
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-securityVpcTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_route_table_association" "securityVpcRtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.securityVpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwSecurity.id
}

################### TGW - Internet VPC stuff #######
resource "aws_ec2_transit_gateway_vpc_attachment" "internetVpcTgwAttachment" {
  subnet_ids                                      = [aws_subnet.subnetInternetTgwAttachmentAz1.id, aws_subnet.subnetInternetTgwAttachmentAz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.internetVpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-internetVpcTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_route_table_association" "internetVpcRtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internetVpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwIngress.id
}




##################################################################### Transit gateway #############################################################

##################################################################### Internet VPC #############################################################
resource "aws_vpc" "internetVpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name  = "${var.projectPrefix}-internetVpc-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

# Subnets

resource "aws_subnet" "subnetInternetNatgAz1" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.53.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetNatgAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetInternetNatgAz2" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.153.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetNatgAz2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetInternetJumphostAz1" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.10.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetJumphostAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetInternetJumphostAz2" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.110.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetJumphostAz2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetInternetTgwAttachmentAz1" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.52.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetJumphostAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
resource "aws_subnet" "subnetInternetTgwAttachmentAz2" {
  vpc_id            = aws_vpc.internetVpc.id
  cidr_block        = "10.1.152.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-subnetInternetJumphostAz2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

# Internet Gateway

resource "aws_internet_gateway" "internetVpcIgw" {
  vpc_id = aws_vpc.internetVpc.id

  tags = {
    Name  = "${var.projectPrefix}-internetVpcIgw-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#nat gatewaty

resource "aws_eip" "internetVpcNatgwAz1Eip" {
  vpc = true
  tags = {
    Name  = "${var.projectPrefix}-internetVpcNatgwAz1Eip-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_eip" "internetVpcNatgwAz2Eip" {
  vpc = true
  tags = {
    Name  = "${var.projectPrefix}-internetVpcNatgwAz2Eip-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_nat_gateway" "internetVpcNatgwAz1" {
  allocation_id = aws_eip.internetVpcNatgwAz1Eip.id
  subnet_id     = aws_subnet.subnetInternetNatgAz1.id
}

resource "aws_nat_gateway" "internetVpcNatgwAz2" {
  allocation_id = aws_eip.internetVpcNatgwAz2Eip.id
  subnet_id     = aws_subnet.subnetInternetNatgAz2.id
}

# Route Tables

resource "aws_route_table" "rtInternetVpc" {
  vpc_id = aws_vpc.internetVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetVpcIgw.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name  = "${var.projectPrefix}-rtInternetVpc-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_route_table" "rtInternetVpcTgwAttachmentSubnets" {
  vpc_id = aws_vpc.internetVpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.internetVpcNatgwAz1.id
  }
  tags = {
    Name  = "${var.projectPrefix}-rtInternetVpcTgwAttachmentSubnets-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#route table associations

resource "aws_main_route_table_association" "internetVpcRtbAssociation" {
  vpc_id         = aws_vpc.internetVpc.id
  route_table_id = aws_route_table.rtInternetVpc.id
}

resource "aws_route_table_association" "internetVpcTgwAttachmentSubnetAz1RtbAssociation" {
  subnet_id      = aws_subnet.subnetInternetTgwAttachmentAz1.id
  route_table_id = aws_route_table.rtInternetVpcTgwAttachmentSubnets.id
}

resource "aws_route_table_association" "internetVpcTgwAttachmentSubnetAz2RtbAssociation" {
  subnet_id      = aws_subnet.subnetInternetTgwAttachmentAz2.id
  route_table_id = aws_route_table.rtInternetVpcTgwAttachmentSubnets.id
}



########################################################################################################################################################

##################################################################### Security VPC #############################################################

##################################################################### Security VPC #############################################################


#Spoke10 VPC
module "spoke10Vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-spoke10Vpc-${random_id.buildSuffix.hex}"

  cidr                               = "10.10.0.0/16"
  azs                                = [local.awsAz1, local.awsAz2]
  database_subnets                   = ["10.10.20.0/24", "10.10.120.0/24"]
  create_database_subnet_group       = false
  create_database_subnet_route_table = true

}

resource "aws_route" "spoke10VpcDatabaseRtb" {
  route_table_id         = module.spoke10Vpc.database_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  depends_on             = [aws_ec2_transit_gateway.tgw]
}
resource "aws_default_route_table" "spoke10VpcDefaultRtb" {
  default_route_table_id = module.spoke10Vpc.default_route_table_id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke10VpcTgwAttachment" {
  subnet_ids                                      = [module.spoke10Vpc.database_subnets[0], module.spoke10Vpc.database_subnets[1]]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.spoke10Vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-spoke10VpcTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke10RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke10VpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwIngress.id
}

#Spoke20 VPC
module "spoke20Vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-spoke20Vpc-${random_id.buildSuffix.hex}"

  cidr = "10.20.0.0/16"

  azs                                = [local.awsAz1, local.awsAz2]
  database_subnets                   = ["10.20.20.0/24", "10.20.120.0/24"]
  create_database_subnet_group       = false
  create_database_subnet_route_table = true

}

resource "aws_route" "spoke20VpcDatabaseRtb" {
  route_table_id         = module.spoke20Vpc.database_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  depends_on             = [aws_ec2_transit_gateway.tgw]
}
resource "aws_default_route_table" "spoke20VpcDefaultRtb" {
  default_route_table_id = module.spoke20Vpc.default_route_table_id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke20VpcTgwAttachment" {
  subnet_ids                                      = [module.spoke20Vpc.database_subnets[0], module.spoke20Vpc.database_subnets[1]]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.spoke20Vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name  = "${var.projectPrefix}-spoke20VpcTgwAttachment-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke20RtAssociation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke20VpcTgwAttachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtTgwIngress.id
}


#################################Security Vpc = GWLB and BIGIPs

resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${random_id.buildSuffix.hex}"
  public_key = var.sshPublicKey
}

module "gwlb-bigip" {
  source             = "../../../../modules/aws/terraform/gwlb-bigip-vpc"
  projectPrefix      = var.projectPrefix
  resourceOwner      = var.resourceOwner
  keyName            = aws_key_pair.deployer.id
  buildSuffix        = random_id.buildSuffix.hex
  instanceCount      = 1
  vpcGwlbSubPubACidr = "10.252.10.0/24"
  vpcGwlbSubPubBCidr = "10.252.110.0/24"
  subnetGwlbeAz1     = "10.252.54.0/24"
  subnetGwlbeAz2     = "10.252.154.0/24"
  createGwlbEndpoint = true
}

############subnets
resource "aws_subnet" "securityVpcSubnetTgwAttachmentAz1" {
  vpc_id            = module.gwlb-bigip.vpcs["vpcGwlb"]
  cidr_block        = "10.252.52.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-securityVpcSubnetTgwAttachmentAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "securityVpcSubnetTgwAttachmentAz2" {
  vpc_id            = module.gwlb-bigip.vpcs["vpcGwlb"]
  cidr_block        = "10.252.152.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-securityVpcSubnetTgwAttachmentAz2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

# route tables

resource "aws_route_table" "rtGwlbEndpointSubnets" {
  vpc_id = module.gwlb-bigip.vpcs["vpcGwlb"]

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name  = "${var.projectPrefix}-rtGwlbEndpointSubnets-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}


resource "aws_route_table" "rtTgwAttachmentSubnetAz1" {
  vpc_id = module.gwlb-bigip.vpcs["vpcGwlb"]

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.gwlb-bigip.gwlbeAz1
  }
  tags = {
    Name  = "${var.projectPrefix}-rtTgwAttachmentSubnetAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
resource "aws_route_table" "rtTgwAttachmentSubnetAz2" {
  vpc_id = module.gwlb-bigip.vpcs["vpcGwlb"]

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.gwlb-bigip.gwlbeAz2
  }
  tags = {
    Name  = "${var.projectPrefix}-rtTgwAttachmentSubnetAz2-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
# route table association

resource "aws_route_table_association" "GwlbEndpointSubnetAz1RtbAssociation" {
  subnet_id      = module.gwlb-bigip.subnetGwlbeAz1
  route_table_id = aws_route_table.rtGwlbEndpointSubnets.id
}

resource "aws_route_table_association" "GwlbEndpointSubnetAz2RtbAssociation" {
  subnet_id      = module.gwlb-bigip.subnetGwlbeAz2
  route_table_id = aws_route_table.rtGwlbEndpointSubnets.id
}

resource "aws_route_table_association" "TgwAttachmentSubnetAz1RtbAssociation" {
  subnet_id      = aws_subnet.securityVpcSubnetTgwAttachmentAz1.id
  route_table_id = aws_route_table.rtTgwAttachmentSubnetAz1.id
}

resource "aws_route_table_association" "TgwAttachmentSubnetAz2RtbAssociation" {
  subnet_id      = aws_subnet.securityVpcSubnetTgwAttachmentAz2.id
  route_table_id = aws_route_table.rtTgwAttachmentSubnetAz2.id
}



#########Compute
#local for spinning up compute resources
locals {

  vpcs = {

    internetVpcData = {
      vpcId    = aws_vpc.internetVpc.id
      subnetId = aws_subnet.subnetInternetJumphostAz1.id
    }

    spoke10VpcData = {
      vpcId    = module.spoke10Vpc.vpc_id
      subnetId = module.spoke10Vpc.database_subnets[0]
    }
    spoke20VpcData = {
      vpcId    = module.spoke20Vpc.vpc_id
      subnetId = module.spoke20Vpc.database_subnets[0]
    }

  }

}

resource "aws_security_group" "secGroupWorkstation" {
  for_each    = local.vpcs
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
    from_port   = 80
    to_port     = 80
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


module "jumphost" {
  for_each      = local.vpcs
  source        = "../../../../modules/aws/terraform/workstation/"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = each.value["vpcId"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = each.value["subnetId"]
  securityGroup = aws_security_group.secGroupWorkstation[each.key].id
  associateEIP  = each.key == "internetVpcData" ? true : false
}
