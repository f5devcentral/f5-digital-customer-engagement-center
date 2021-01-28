
provider "aws" {
  region = var.awsRegion
}

resource "random_id" "id" {
  byte_length = 2
}

resource "aws_key_pair" "deployer" {
  key_name   = format("%s-key-%s", var.userId, random_id.id.hex)
  public_key = var.sshPublicKey
}

module "gwlb-bigip-vpc" {
  source        = "../../../modules/aws/terraform/gwlb-bigip-vpc"
  project       = var.project
  userId        = var.userId
  awsRegion     = var.awsRegion
  keyName       = aws_key_pair.deployer.id
  instanceCount = 1
}

# VPCs

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
}
resource "aws_vpc" "vpcMain" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name  = "${var.project}-vpcMain"
    Owner = var.userId
  }
}

# Subnets

resource "aws_subnet" "vpcMainSubPubA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.10.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubPubA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPubB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.110.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubPubB"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainGwlbeA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.52.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubGwlbeA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubGwlbeB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.152.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubGwlbeB"
    Owner = var.userId
  }
}

# Internet Gateway

resource "aws_internet_gateway" "vpcMainIgw" {
  vpc_id = aws_vpc.vpcMain.id

  tags = {
    Name  = "${var.project}-vpcMainIgw"
    Owner = var.userId
  }
}

# Main Route Tables Associations
## Forcing our Route Tables to be the main ones for our VPCs,
## otherwise AWS automatically will create a main Route Table
## for each VPC, leaving our own Route Tables as secondary

resource "aws_main_route_table_association" "mainRtbAssoVpcMain" {
  vpc_id         = aws_vpc.vpcMain.id
  route_table_id = aws_route_table.vpcMainRtb.id
}

# Route Tables

resource "aws_route_table" "vpcMainRtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcMainIgw.id
  }

  tags = {
    Name  = "${var.project}-vpcMainRtb"
    env   = "shared"
    Owner = var.userId
  }
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
  private_ip                  = "10.1.10.100"
  associate_public_ip_address = true

  tags = {
    Name  = "GeneveProxy"
    Owner = var.userId
  }
}
