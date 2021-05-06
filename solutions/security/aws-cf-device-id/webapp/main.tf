provider "aws" {
  region = var.awsRegion
}

data "aws_route53_zone" "this" {
  name = var.domainName
}
data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  awsAz1 = data.aws_availability_zones.available.names[0]
  awsAz2 = data.aws_availability_zones.available.names[1]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpc-${random_id.buildSuffix.hex}"

  cidr = "10.1.0.0/16"

  azs                  = [local.awsAz1, local.awsAz2]
  public_subnets       = ["10.1.10.0/24", "10.1.110.0/24"]
  private_subnets      = ["10.1.20.0/24", "10.1.120.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-vpc-${random_id.buildSuffix.hex}"
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.resourceOwner}-${var.projectPrefix}"
  public_key = var.sshPublicKey
}

resource "aws_security_group" "secGroupWebapp" {
  description = "Jumphost workstation security group"
  vpc_id      = module.vpc.vpc_id

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
    Name  = "${var.projectPrefix}-secGroupWorkstation"
    Owner = var.resourceOwner
  }
}


module "webApp" {
  source         = "../../../../modules/aws/terraform/webServer"
  projectPrefix  = var.projectPrefix
  resourceOwner  = var.resourceOwner
  vpc            = module.vpc.vpc_id
  keyName        = aws_key_pair.deployer.id
  subnets        = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  albSubnets     = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  securityGroup  = aws_security_group.secGroupWebapp.id
  jsScriptTag    = "<script async defer src=\"https://${var.subDomain}.${var.domainName}${var.jsScriptTag}\" id=\"_imp_apg_dip_\"  ></script>"
  startupCommand = "docker run -d --restart always -p 80:80 -v /var/tmp/html:/usr/share/nginx/html -v /tmp/nginx.conf:/etc/nginx/conf.d/default.conf nginx"
}
