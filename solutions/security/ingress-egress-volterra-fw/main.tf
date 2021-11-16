###########################Versions##########################
terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.10"
    }
    aws = ">= 3"
  }
}

###########################providers##########################
provider "aws" {
  region = var.awsRegion
}

provider "volterra" {
  timeout = "90s"
}
############################ Locals ############################

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}

locals {
  buildSuffix = coalesce(var.buildSuffix, random_id.buildSuffix.hex)
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsAz3 = var.awsAz3 != null ? var.awsAz1 : data.aws_availability_zones.available.names[2]
  


  awsCommonLabels = merge(var.awsLabels, {})
  volterraCommonLabels = merge(var.labels, {
    demo     = "volterra-aws-fw"
    owner    = var.resourceOwner
    prefix   = var.projectPrefix
    suffix   = local.buildSuffix
    platform = "aws"
  })
  volterraCommonAnnotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}

############################ VPCs ############################

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 2.0"
  name                 = format("%s-vpc-%s", var.projectPrefix, local.buildSuffix)
  cidr                 = var.vpcData["cidr"]
  azs                  = [local.awsAz1, local.awsAz2]
  public_subnets       = var.vpcData["public_subnets"]
  private_subnets      = var.vpcData["private_subnets"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags = merge(local.volterraCommonLabels, {
    info = "volt-fw"
  })
}

############################ Workload Subnet ############################

resource "aws_subnet" "sli" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = var.vpcData["sli_cidr_block"]

  tags = {
    Name      = format("%s-site-local-inside-%s-%s", var.resourceOwner, "gwlb-vpc", local.buildSuffix)
    Terraform = "true"
  }
}

resource "aws_subnet" "workload" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = local.awsAz1
  cidr_block        = var.vpcData["workload_cidr_block"]

  tags = {
    Name      = format("%s-workload-%s-%s", var.resourceOwner, "gwlb-vpc", local.buildSuffix)
    Terraform = "true"
  }
}

##################GWLB#################

resource "aws_lb" "gwlb" {
  internal           = false
  load_balancer_type = "gateway"
  subnets            = module.vpc.public_subnets

  tags = {
    Name  = "${var.projectPrefix}-gwlb-${local.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group" "bigipTargetGroup" {
  name        = "bigipTG-${local.buildSuffix}"
  port        = 6081
  protocol    = "GENEVE"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  health_check {
    protocol = "TCP"
    port     = 80
    #    matcher  = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "bigipTargetGroupAttachment" {
  count            = var.bigipInstanceCount
  target_group_arn = aws_lb_target_group.bigipTargetGroup.arn
  target_id        = module.bigip[count.index].bigip_instance_ids[0]
}


resource "aws_vpc_endpoint_service" "gwlbEndpointService" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
}

resource "aws_lb_listener" "gwlbListener" {
  load_balancer_arn = aws_lb.gwlb.id

  default_action {
    target_group_arn = aws_lb_target_group.bigipTargetGroup.id
    type             = "forward"
  }
}

##########BIGIP################

data "local_file" "customUserData" {
  filename = "${path.module}/f5_onboard.tmpl"
}
resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${random_id.buildSuffix.hex}"
  public_key = var.ssh_key
}

module "mgmt-network-security-group" {
  version = "v4.2.0"
  source  = "terraform-aws-modules/security-group/aws"

  name        = "${var.projectPrefix}-mgmt-nsg-${local.buildSuffix}"
  description = "Security group for BIG-IP Management"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.allowedMgmtIps
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "https-8443-tcp", "ssh-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 6081
      to_port     = 6081
      protocol    = "udp"
      description = "Geneve for GWLB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

# Create BIG-IP

module "bigip" {
  count                  = var.bigipInstanceCount
  source                 = "../../../modules/aws/terraform/terraform-aws-bigip-module/"
  prefix                 = format("%s-1nic", var.projectPrefix)
  ec2_key_name           = aws_key_pair.deployer.id
  mgmt_subnet_ids        = [{ "subnet_id" = aws_subnet.sli.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids = [module.mgmt-network-security-group.security_group_id]
  f5_ami_search_name     = "*F5 BIGIP-16.1* PAYG-Best 1Gbps*"
  custom_user_data       = data.local_file.customUserData.content
}
