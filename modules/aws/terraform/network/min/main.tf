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
  cidr_block = var.vpcMainCidr
  tags = {
    Name  = "${var.projectPrefix}-vpcMain-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

# Subnets

resource "aws_subnet" "vpcMainSubPubA" {
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = var.vpcMainSubPubACidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPubA-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPubB" {
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = var.vpcMainSubPubBCidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPubB-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubMgmtA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubMgmtACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubMgmtA-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubMgmtB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubMgmtBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubMgmtB-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPrivA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPrivACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPrivA-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcMainSubPrivB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = var.vpcMainSubPrivBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcMainSubPrivB-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

# Internet Gateway

resource "aws_internet_gateway" "vpcMainIgw" {
  vpc_id = aws_vpc.vpcMain.id

  tags = {
    Name  = "${var.projectPrefix}-vpcMainIgw-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

# Main Route Tables Associations

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
    Name  = "${var.projectPrefix}-vpcMainRtb-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}
