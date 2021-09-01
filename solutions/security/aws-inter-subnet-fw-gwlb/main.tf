
provider "aws" {
  region = var.awsRegion
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.resourceOwner}-${var.projectPrefix}"
  public_key = var.sshPublicKey
}

data "local_file" "customUserData" {
  filename = "${path.module}/f5_onboard.tmpl"
}
module "gwlb-bigip-vpc" {
  source             = "../../../modules/aws/terraform/gwlb-bigip-vpc"
  projectPrefix      = var.projectPrefix
  resourceOwner      = var.resourceOwner
  buildSuffix        = random_id.buildSuffix.hex
  keyName            = aws_key_pair.deployer.id
  bigipInstanceCount = 1
  customUserData     = data.local_file.customUserData.content
}

# VPCs

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz2 : data.aws_availability_zones.available.names[1]
}
resource "aws_vpc" "vpcMain" {
  cidr_block = var.vpcMainCidr
  tags = {
    Name  = "${var.projectPrefix}-vpcMain-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

# Subnets

resource "aws_subnet" "vpcMainSubPubA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPubACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPubA-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPubB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPubBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPubB-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPrivA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPrivACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPrivA-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPrivB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPrivBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPrivB-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
resource "aws_subnet" "vpcMainSubGwlbeA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubGwlbeACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubGwlbeA-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubGwlbeB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubGwlbeBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubGwlbeB-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#vpc endpoints for GWLB

resource "aws_vpc_endpoint" "vpcMainGwlbeA" {
  service_name      = module.gwlb-bigip-vpc.gwlbEndpointService
  subnet_ids        = [aws_subnet.vpcMainSubGwlbeA.id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpcMain.id
}

resource "aws_vpc_endpoint" "vpcMainGwlbeB" {
  service_name      = module.gwlb-bigip-vpc.gwlbEndpointService
  subnet_ids        = [aws_subnet.vpcMainSubGwlbeB.id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpcMain.id
}

# Internet Gateway

resource "aws_internet_gateway" "vpcMainIgw" {
  vpc_id = aws_vpc.vpcMain.id

  tags = {
    Name  = "${var.projectPrefix}-vpcMainIgw-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

# Route Tables

resource "aws_route_table" "vpcMainAz1Rtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }

  route {
    cidr_block      = "10.1.10.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }

  route {
    cidr_block      = "10.1.20.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }
  route {
    cidr_block      = "10.1.120.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }
  route {
    cidr_block      = "10.1.110.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }
  tags = {
    Name  = "${var.projectPrefix}-vpcMainAz1Rtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_route_table" "vpcMainAz2Rtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }

  route {
    cidr_block      = "10.1.110.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }

  route {
    cidr_block      = "10.1.120.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }
  route {
    cidr_block      = "10.1.10.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }

  route {
    cidr_block      = "10.1.20.0/24"
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }
  tags = {
    Name  = "${var.projectPrefix}-vpcMainAz2Rtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_route_table" "vpcMainIgwRtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block      = var.vpcMainSubPubACidr
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }

  route {
    cidr_block      = var.vpcMainSubPubBCidr
    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }

  tags = {
    Name  = "${var.projectPrefix}-vpcMainIgwRtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_route_table" "vpcMainSubGwlbeRtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcMainIgw.id
  }

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubGwlbeRtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#route table associations

resource "aws_route_table_association" "publicSubnetAz1RtbAssociation" {
  subnet_id      = aws_subnet.vpcMainSubPubA.id
  route_table_id = aws_route_table.vpcMainAz1Rtb.id
}

resource "aws_route_table_association" "privateSubnetAz1RtbAssociation" {
  subnet_id      = aws_subnet.vpcMainSubPrivA.id
  route_table_id = aws_route_table.vpcMainAz1Rtb.id
}

resource "aws_route_table_association" "publicSubnetAz2RtbAssociation" {
  subnet_id      = aws_subnet.vpcMainSubPubB.id
  route_table_id = aws_route_table.vpcMainAz2Rtb.id
}

resource "aws_route_table_association" "privateSubnetAz2RtbAssociation" {
  subnet_id      = aws_subnet.vpcMainSubPrivB.id
  route_table_id = aws_route_table.vpcMainAz2Rtb.id
}

resource "aws_route_table_association" "vpcMainIgwRtbAssociation" {
  gateway_id     = aws_internet_gateway.vpcMainIgw.id
  route_table_id = aws_route_table.vpcMainIgwRtb.id
}

resource "aws_route_table_association" "vpcMainSubGwlbeRtbAssociationA" {
  subnet_id      = aws_subnet.vpcMainSubGwlbeA.id
  route_table_id = aws_route_table.vpcMainSubGwlbeRtb.id
}

resource "aws_route_table_association" "vpcMainSubGwlbeRtbAssociationB" {
  subnet_id      = aws_subnet.vpcMainSubGwlbeB.id
  route_table_id = aws_route_table.vpcMainSubGwlbeRtb.id
}

# security groups

module "jumphost-security-group" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.projectPrefix}-jumphost-nsg-${random_id.buildSuffix.hex}"
  description = "Security group for jumphost"
  vpc_id      = aws_vpc.vpcMain.id

  ingress_cidr_blocks = [var.adminSourceCidr]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "https-8443-tcp", "ssh-tcp"]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "ubuntuVpcMainSubnetA" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.vpcMainSubPubA.id
  key_name                    = aws_key_pair.deployer.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.jumphost-security-group.security_group_id]

  tags = {
    Name  = "${var.projectPrefix}-ubuntuVpcMainSubnetA-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_instance" "internalUbuntuAz1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.vpcMainSubPrivA.id
  key_name                    = aws_key_pair.deployer.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.jumphost-security-group.security_group_id]

  tags = {
    Name  = "${var.projectPrefix}-internalUbuntuAz1-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
