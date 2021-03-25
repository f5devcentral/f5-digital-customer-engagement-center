#
# Create a random id
#
#
module "vpcDns" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.projectPrefix}-vpcDns-${random_id.buildSuffix.hex}"

  cidr = "100.64.200.0/21"

  azs                                = [local.awsAz1, local.awsAz2]
  public_subnets                     = ["100.64.200.0/24", "100.64.201.0/24"]
  intra_subnets                     = ["100.64.203.0/24", "100.64.204.0/24"]

  enable_dns_hostnames = true
  tags                               = { 
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-vpcDns-${random_id.buildSuffix.hex}"
    }

}
resource "aws_route53_resolver_endpoint" "resolverAcmeDns" {
  name      = "resolverAcmeDns"
  direction = "OUTBOUND"

  security_group_ids = [
    module.vpcDns.default_security_group_id
  ]

  ip_address {
    subnet_id = module.vpcDns.intra_subnets[0]
  }

  ip_address {
    subnet_id = module.vpcDns.intra_subnets[1]
  }

  tags = {
    resourceOwner = var.resourceOwner
    project       = "${var.projectPrefix}-resolverAcmeDns-${random_id.buildSuffix.hex}"
  }
}

# Create random password for BIG-IP
#
resource random_string password {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}
#
# Create Secret Store and Store BIG-IP Password
#
resource "aws_secretsmanager_secret" "bigip" {
  name = format("%s-bigip-secret-%s", var.projectPrefix, random_id.buildSuffix.hex)
}

resource "aws_secretsmanager_secret_version" "bigip-pwd" {
  secret_id     = aws_secretsmanager_secret.bigip.id
  secret_string = random_string.password.result
}

#
#
# Create a security group for BIG-IP Management
#
module "mgmt-network-security-group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-mgmt-nsg-%s", var.projectPrefix, random_id.buildSuffix.hex)
  description = "Security group for BIG-IP Management"
  vpc_id      = module.vpcDns.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "https-8443-tcp", "ssh-tcp", "dns-udp", "dns-tcp" ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

#
# Create BIG-IP
#
module bigip {
  source       = "github.com/yossi-r/terraform-aws-bigip-module"
  count        = 1
  prefix       = format("%s-1nic", var.projectPrefix)
  ec2_key_name = aws_key_pair.deployer.id
  f5_password  = random_string.password.result
  //aws_secretmanager_auth      = false
  //aws_secretmanager_secret_id = aws_secretsmanager_secret.bigip.id
  //aws_iam_instance_profile    = aws_iam_instance_profile.instance_profile.name
  mgmt_subnet_ids        = [{ "subnet_id" = module.vpcDns.public_subnets[0], "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids = [module.mgmt-network-security-group.this_security_group_id]
}

resource "null_resource" "clusterDO" {
  count = 1
  provisioner "local-exec" {
    command = "cat > DO_1nic.json <<EOL\n ${module.bigip[count.index].onboard_do}\nEOL"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf DO_1nic.json"
  }
  depends_on = [module.bigip]
}


#
# Variables used by this example
#
locals {
  allowed_mgmt_cidr = "0.0.0.0/0"
  allowed_app_cidr  = "0.0.0.0/0"
}