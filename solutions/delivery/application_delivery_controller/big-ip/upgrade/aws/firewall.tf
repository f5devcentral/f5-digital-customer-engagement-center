# Create a security group for BIG-IP Management

module "bigip_mgmt_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "3.18.0"
  name                = format("%s-bigip-mgmt-%s", var.projectPrefix, random_id.id.hex)
  description         = "Security group for Management BIG-IP Interface"
  vpc_id              = module.aws_network.vpcs["main"]
  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
  ingress_rules       = ["https-443-tcp", "https-8443-tcp", "ssh-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_mgmt_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Create a security group for BIG-IP Public

module "bigip_external_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "3.18.0"
  name                = format("%s-bigip-%s", var.projectPrefix, random_id.id.hex)
  description         = "Security group for external BIG-IP Interface"
  vpc_id              = module.aws_network.vpcs["main"]
  ingress_cidr_blocks = [var.allowedIps]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_external_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

# Create a security group for BIG-IP Private

module "bigip_internal_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "3.18.0"
  name                = format("%s-bigip-mgmt-%s", var.projectPrefix, random_id.id.hex)
  description         = "Security group for internal BIG-IP Interface"
  vpc_id              = module.aws_network.vpcs["main"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_internal_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}
