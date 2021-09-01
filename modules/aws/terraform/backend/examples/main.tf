provider "aws" {
  region = var.awsRegion
}

module "aws_network" {
  source        = "../../network/min"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  awsRegion     = var.awsRegion
  buildSuffix   = random_id.buildSuffix.hex
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.resourceOwner}-${var.projectPrefix}"
  public_key = var.sshPublicKey
}

resource "aws_security_group" "secGroupWorkstation" {
  name        = "secGroupWorkstation"
  description = "Jumphost workstation security group"
  vpc_id      = module.aws_network.vpcs["main"]

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


module "jumphost" {
  source        = "../"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = module.aws_network.vpcs["main"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = module.aws_network.subnetsAz1["public"]
  securityGroup = aws_security_group.secGroupWorkstation.id
}
