provider "aws" {
  region = var.awsRegion
}

###############
# VPC Section #
###############

# VPCs

resource "aws_vpc" "vpcMain" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name  = "${var.project}-vpcMain"
    Owner = var.userId
    env   = "shared"
  }
}


# Subnets

resource "aws_subnet" "vpcMainSubPubA" {
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = "10.1.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubPubA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPubB" {
  vpc_id                  = aws_vpc.vpcMain.id
  cidr_block              = "10.1.110.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubPubB"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubMgmtA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = var.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubMgmtA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubMgmtB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.101.0/24"
  availability_zone = var.awsAz2

  tags = {
    Name  = "${var.project}-vpcMainSubMgmtB"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPrivA" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.20.0/24"
  availability_zone = var.awsAz1

  tags = {
    Name  = "${var.project}-vpcMainSubPrivA"
    Owner = var.userId
  }
}

resource "aws_subnet" "vpcMainSubPrivB" {
  vpc_id            = aws_vpc.vpcMain.id
  cidr_block        = "10.1.120.0/24"
  availability_zone = var.awsAz2

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

##########################
# EC2 Instances Section #
##########################


# Security Groups
## Need to create 4 of them as our Security Groups are linked to a VPC

resource "aws_security_group" "secGroupVpcMainWeb" {
  name        = "${var.project}-secGroupVpcMainWeb"
  description = "web traffic"
  vpc_id      = aws_vpc.vpcMain.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project}-secGroupVpcMainWeb"
    Owner = var.userId
  }
}

resource "aws_security_group" "secGroupVpcMainBigip" {
  name        = "secGroupVpcMainBigip"
  description = "allow bigip protocols"
  vpc_id      = aws_vpc.vpcMain.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project}-secGroupVpcMainBigip"
    Owner = var.userId
  }
}

# VMs

resource "aws_key_pair" "awsKeyPair" {
  key_name_prefix = var.userId
  public_key      = var.sshPublicKey
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

resource "aws_instance" "jumphostVpcMain" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jumphostInstanceType
  subnet_id                   = aws_subnet.vpcMainSubPubA.id
  vpc_security_group_ids      = [aws_security_group.secGroupVpcMainBigip.id]
  key_name                    = aws_key_pair.awsKeyPair.id
  private_ip                  = "10.1.10.10"
  associate_public_ip_address = true

  tags = {
    Name  = "${var.project}-jumphostVpcMain"
    env   = "shared"
    az    = var.awsAz1
    vpc   = "main"
    Owner = var.userId
  }
}
