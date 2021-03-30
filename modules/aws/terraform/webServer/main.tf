# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "applicationServer" {
  template = file("${path.module}/templates/cloud-config-base.yaml")

  vars = {
    startupCommand = var.startupCommand
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = var.projectPrefix

  load_balancer_type = "application"

  vpc_id             = var.vpc
  subnets            = var.albSubnets
  security_groups    = [var.securityGroup]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

#  https_listeners = [
#    {
#      port               = 80
#      protocol           = "HTTP"
#      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#      target_group_index = 0
#    }
#  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.projectPrefix

  # Launch configuration
  lc_name = var.projectPrefix

  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instanceType
  security_groups = [var.securityGroup]
  user_data     = data.template_file.applicationServer.rendered
  key_name      = var.keyName
  target_group_arns = module.alb.target_group_arns
  associate_public_ip_address = var.associatePublicIp

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = var.projectPrefix
  vpc_zone_identifier       = var.subnets
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 5
  desired_capacity          = var.desiredCapacity
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Name"
      value               = "${var.projectPrefix}-workstation"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = var.resourceOwner
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}

