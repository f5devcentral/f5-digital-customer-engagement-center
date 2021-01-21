###############
# VPC Section #
###############

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
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = "10.1.10.0/24"
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = local.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubPubA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPubB" {
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = "10.1.110.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubPubB"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubMgmtA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubMgmtA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubMgmtB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.101.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubMgmtB"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPrivA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.20.0/24"
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubPrivA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPrivB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.120.0/24"
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubPrivB"
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
