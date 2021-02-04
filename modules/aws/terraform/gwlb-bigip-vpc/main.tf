###############
# VPC Section #
###############

# VPCs

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  awsAz1 = var.awsAz1 != null ? var.awsAz1 : data.aws_availability_zones.available.names[0]
  awsAz2 = var.awsAz2 != null ? var.awsAz1 : data.aws_availability_zones.available.names[1]
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
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = aws_vpc.vpcGwlb.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = 80
    matcher  = "200-399"
  }
  tags = {
    Name  = "${var.projectPrefix}-bigipTargetGroup-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group_attachment" "bigipTargetGroupAttachmentAz1" {
  target_group_arn = aws_lb_target_group.bigipTargetGroup.arn
  target_id        = aws_instance.GeneveProxyAz1.private_ip
}

resource "aws_lb_target_group_attachment" "bigipTargetGroupAttachmentAz2" {
  target_group_arn = aws_lb_target_group.bigipTargetGroup.arn
  target_id        = aws_instance.GeneveProxyAz2.private_ip
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
            "arn:aws:secretsmanager:${var.awsRegion}:${data.aws_caller_identity.current.account_id}:secret:*"
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

# bash script template
data "template_file" "onboard" {
  template = file("${path.module}/files/onboard.sh")
  vars = {
    repositories = var.repositories
  }
}

data "template_cloudinit_config" "GeneveProxy" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/files/cloud-config-base.yaml")
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.onboard.rendered
  }

}

resource "aws_instance" "GeneveProxyAz1" {
  ami                         = data.aws_ami.ubuntu.id
  user_data                   = data.template_cloudinit_config.GeneveProxy.rendered
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.vpcGwlbSubPubA.id
  vpc_security_group_ids      = [module.mgmt-network-security-group.this_security_group_id]
  key_name                    = var.keyName
  associate_public_ip_address = true

  tags = {
    Name  = "${var.projectPrefix}-GeneveProxyAz1-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}

resource "aws_instance" "GeneveProxyAz2" {
  ami                         = data.aws_ami.ubuntu.id
  user_data                   = data.template_cloudinit_config.GeneveProxy.rendered
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.vpcGwlbSubPubB.id
  vpc_security_group_ids      = [module.mgmt-network-security-group.this_security_group_id]
  key_name                    = var.keyName
  associate_public_ip_address = true

  tags = {
    Name  = "${var.projectPrefix}-GeneveProxyAz2-${var.buildSuffix}"
    Owner = var.resourceOwner
  }
}


# Create BIG-IP

#module bigipAz1 {
#  source       = "../terraform-aws-bigip-module"
#  count        = var.instanceCount
#  prefix       = format("%s-1nic", var.projectPrefix)
#  ec2_key_name = var.keyName
#  //aws_secretmanager_auth      = false
#  //aws_secretmanager_secret_id = aws_secretsmanager_secret.bigip.id
#  //aws_iam_instance_profile    = aws_iam_instance_profile.instance_profile.name
#  mgmt_subnet_ids        = [{ "subnet_id" = aws_subnet.vpcGwlbSubPubA.id, "public_ip" = true, "private_ip_primary" = "" }]
#  mgmt_securitygroup_ids = [module.mgmt-network-security-group.this_security_group_id]
#  f5_ami_search_name     = "*F5 BIGIP-16.0.1-0.0.3* PAYG-Best 200Mbps*"
#}
#
#resource "null_resource" "clusterDO" {
#  count = var.instanceCount
#  provisioner "local-exec" {
#    command = "cat > DO_1nic.json <<EOL\n ${module.bigipAz1[count.index].onboard_do}\nEOL"
#  }
#  provisioner "local-exec" {
#    when    = destroy
#    command = "rm -rf DO_1nic.json"
#  }
#  depends_on = [module.bigipAz1]
#}
