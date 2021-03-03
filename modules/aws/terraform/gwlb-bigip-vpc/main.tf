###############
# VPC Section #
###############

# VPCs

data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  awsAz1    = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2    = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
  awsRegion = data.aws_region.current.name
}
resource "aws_vpc" "vpcGwlb" {
  cidr_block = var.vpcCidr
  tags = {
    Name  = "${var.projectPrefix}-vpcGwlb-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

# Subnets

resource "aws_subnet" "vpcGwlbSubPubA" {
  vpc_id            = aws_vpc.vpcGwlb.id
  cidr_block        = var.vpcGwlbSubPubACidr
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-vpcGwlbSubPubA-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "vpcGwlbSubPubB" {
  vpc_id            = aws_vpc.vpcGwlb.id
  cidr_block        = var.vpcGwlbSubPubBCidr
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-vpcGwlbSubPubB-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetGwlbeAz1" {
  count             = var.createGwlbEndpoint ? 1 : 0
  vpc_id            = aws_vpc.vpcGwlb.id
  cidr_block        = var.subnetGwlbeAz1
  availability_zone = local.awsAz1

  tags = {
    Name  = "${var.projectPrefix}-subnetGwlbeAz1-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_subnet" "subnetGwlbeAz2" {
  count             = var.createGwlbEndpoint ? 1 : 0
  vpc_id            = aws_vpc.vpcGwlb.id
  cidr_block        = var.subnetGwlbeAz2
  availability_zone = local.awsAz2

  tags = {
    Name  = "${var.projectPrefix}-subnetGwlbeAz2-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}


# Internet Gateway

resource "aws_internet_gateway" "vpcGwlbIgw" {
  vpc_id = aws_vpc.vpcGwlb.id

  tags = {
    Name  = "${var.projectPrefix}-vpcGwlbIgw-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

# Main Route Tables Associations

resource "aws_main_route_table_association" "mainRtbAssoVpcGwlb" {
  vpc_id         = aws_vpc.vpcGwlb.id
  route_table_id = aws_route_table.vpcGwlbRtb.id
}

# Route Tables

resource "aws_route_table" "vpcGwlbRtb" {
  vpc_id = aws_vpc.vpcGwlb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcGwlbIgw.id
  }

  tags = {
    Name  = "${var.projectPrefix}-vpcGwlbRtb-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

##################GWLB#################

resource "aws_lb" "gwlb" {
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.vpcGwlbSubPubA.id, aws_subnet.vpcGwlbSubPubB.id]

  tags = {
    Name  = "${var.projectPrefix}-gwlb-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group" "bigipTargetGroup" {
  name        = "bigipTG-${var.buildSuffix}"
  port        = 6081
  protocol    = "GENEVE"
  target_type = "instance"
  vpc_id      = aws_vpc.vpcGwlb.id

  health_check {
    protocol = "TCP"
    port     = 8443
    #    matcher  = "200-399"
  }
  tags = {
    Name  = "${var.projectPrefix}-bigipTargetGroup-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group_attachment" "bigipTargetGroupAttachmentAz1" {
  target_group_arn = aws_lb_target_group.bigipTargetGroup.arn
  target_id        = module.bigipAz1.bigip_instance_ids[0]
}

#resource "aws_lb_target_group_attachment" "bigipTargetGroupAttachmentAz2" {
#  target_group_arn = aws_lb_target_group.bigipTargetGroup.arn
#  target_id        = aws_instance.GeneveProxyAz2.private_ip
#}

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

resource "aws_vpc_endpoint" "vpcGwlbeAz1" {
  count             = var.createGwlbEndpoint ? 1 : 0
  service_name      = aws_vpc_endpoint_service.gwlbEndpointService.service_name
  subnet_ids        = [aws_subnet.subnetGwlbeAz1[0].id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpcGwlb.id
}

resource "aws_vpc_endpoint" "vpcGwlbeAz2" {
  count             = var.createGwlbEndpoint ? 1 : 0
  service_name      = aws_vpc_endpoint_service.gwlbEndpointService.service_name
  subnet_ids        = [aws_subnet.subnetGwlbeAz2[0].id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpcGwlb.id
}
##########BIGIP################
#
#
# Create random password for BIG-IP
#
resource "aws_iam_role" "main" {
  name               = "${var.projectPrefix}-iam-role-${var.buildSuffix}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "BigIpPolicy" {
  //name = "aws-iam-role-policy-${module.utils.env_prefix}"
  role   = aws_iam_role.main.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeAddresses",
            "ec2:AssociateAddress",
            "ec2:DisassociateAddress",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeNetworkInterfaceAttribute",
            "ec2:DescribeRouteTables",
            "ec2:ReplaceRoute",
            "ec2:CreateRoute",
            "ec2:assignprivateipaddresses",
            "sts:AssumeRole",
            "s3:ListAllMyBuckets"
        ],
        "Resource": [
            "*"
        ],
        "Effect": "Allow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:PutSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds",
            "secretsmanager:UpdateSecretVersionStage"
        ],
        "Resource": [
            "arn:aws:secretsmanager:${local.awsRegion}:${data.aws_caller_identity.current.account_id}:secret:*"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.projectPrefix}-iam-profile-${var.buildSuffix}"
  role = aws_iam_role.main.id
}

module "mgmt-network-security-group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.projectPrefix}-mgmt-nsg-${var.buildSuffix}"
  description = "Security group for BIG-IP Management"
  vpc_id      = aws_vpc.vpcGwlb.id

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

module "bigipAz1" {
  source       = "../terraform-aws-bigip-module"
  prefix       = format("%s-1nic", var.projectPrefix)
  ec2_key_name = var.keyName
  //aws_secretmanager_auth      = false
  //aws_secretmanager_secret_id = aws_secretsmanager_secret.bigip.id
  //aws_iam_instance_profile    = aws_iam_instance_profile.instance_profile.name
  mgmt_subnet_ids        = [{ "subnet_id" = aws_subnet.vpcGwlbSubPubA.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids = [module.mgmt-network-security-group.this_security_group_id]
  f5_ami_search_name     = "*F5 BIGIP-15.1.2.1* PAYG-Best 200Mbps*"
}

resource "null_resource" "clusterDO" {
  provisioner "local-exec" {
    command = "cat > DO_1nic.json <<EOL\n ${module.bigipAz1.onboard_do}\nEOL"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf DO_1nic.json"
  }
  depends_on = [module.bigipAz1]
}
