data "aws_availability_zones" "available" {
  state = "available"
}
##################################################################### Locals #############################################################
locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]
  volterra_common_labels = merge(var.labels, {
    platform = "aws"
  })
  volterra_common_annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}
##################################################################### Locals #############################################################



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

resource "aws_subnet" "bu1VoltSliAz1" {
  vpc_id            = module.vpcBu1.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.30.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu1VoltWorkloadAz1" {
  vpc_id            = module.vpcBu1.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.40.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu1VoltWorkloadAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltSliAz1" {
  vpc_id            = module.vpcBu2.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.30.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "bu2VoltWorkloadAz1" {
  vpc_id            = module.vpcBu2.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.40.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-bu2VoltWorkloadAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltSliAz1" {
  vpc_id            = module.vpcAcme.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.30.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltSliAz1-${var.buildSuffix}"
  }
}

resource "aws_subnet" "acmeVoltWorkloadAz1" {
  vpc_id            = module.vpcAcme.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = "10.1.40.0/24"

  tags = {
    resourceOwner = var.resourceOwner
    Name          = "${var.projectPrefix}-acmeVoltWorkloadAz1-${var.buildSuffix}"
  }
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
