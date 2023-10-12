# BIG-IP Cluster

############################ Locals ############################

locals {
  # Retrieve all BIG-IP secondary IPs
  vm01_ext_ips = {
    0 = {
      ip = sort(aws_network_interface.vm01-ext-nic.private_ips)[0]
    }
    1 = {
      ip = sort(aws_network_interface.vm01-ext-nic.private_ips)[1]
    }
  }
  vm02_ext_ips = {
    0 = {
      ip = sort(aws_network_interface.vm02-ext-nic.private_ips)[0]
    }
    1 = {
      ip = sort(aws_network_interface.vm02-ext-nic.private_ips)[1]
    }
  }
  # Determine BIG-IP secondary IPs to be used for VIP
  vm01_vip_ips = {
    app1 = {
      ip = aws_network_interface.vm01-ext-nic.private_ip != local.vm01_ext_ips.0.ip ? local.vm01_ext_ips.0.ip : local.vm01_ext_ips.1.ip
    }
  }
  vm02_vip_ips = {
    app1 = {
      ip = aws_network_interface.vm02-ext-nic.private_ip != local.vm02_ext_ips.0.ip ? local.vm02_ext_ips.0.ip : local.vm02_ext_ips.1.ip
    }
  }
}
############################ AMI ############################

# Find BIG-IP AMI
data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
}

############################ SSH Key pair ############################

//# Create SSH Key Pair
//resource "aws_key_pair" "bigip" {
//  key_name   = format("%s-key-%s", var.projectPrefix, random_id.buildSuffix.hex)
//  public_key = var.ssh_key
//}

############################ NICs ############################

# Create NIC for Management
resource "aws_network_interface" "vm01-mgmt-nic" {
  subnet_id       = module.aws_network.subnetsAz1["private"]
  security_groups = [module.bigip_mgmt_sg.this_security_group_id]
  tags = {
    Name  = format("%s-vm01-mgmt-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
}

resource "aws_network_interface" "vm02-mgmt-nic" {
  subnet_id       = module.aws_network.subnetsAz1["private"]
  security_groups = [module.bigip_mgmt_sg.this_security_group_id]
  tags = {
    Name  = format("%s-vm02-mgmt-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
}

# Create NIC for External
resource "aws_network_interface" "vm01-ext-nic" {
  subnet_id         = module.aws_network.subnetsAz1["public"]
  security_groups   = [module.bigip_external_sg.this_security_group_id]
  private_ips_count = 1
  source_dest_check = false
  tags = {
    Name                      = format("%s-vm01-ext-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                     = var.resourceOwner
    f5_cloud_failover_label   = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_cloud_failover_nic_map = "external"
  }
}

resource "aws_network_interface" "vm02-ext-nic" {
  subnet_id         = module.aws_network.subnetsAz1["public"]
  security_groups   = [module.bigip_external_sg.this_security_group_id]
  private_ips_count = 1
  source_dest_check = false
  tags = {
    Name                      = format("%s-vm02-ext-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                     = var.resourceOwner
    f5_cloud_failover_label   = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_cloud_failover_nic_map = "external"
  }
}

# Create NIC for Internal
resource "aws_network_interface" "vm01-int-nic" {
  subnet_id         = module.aws_network.subnetsAz1["mgmt"]
  security_groups   = [module.bigip_internal_sg.this_security_group_id]
  source_dest_check = false
  tags = {
    Name                      = format("%s-vm01-int-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                     = var.resourceOwner
    f5_cloud_failover_label   = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_cloud_failover_nic_map = "internal"
  }
}

resource "aws_network_interface" "vm02-int-nic" {
  subnet_id         = module.aws_network.subnetsAz1["mgmt"]
  security_groups   = [module.bigip_internal_sg.this_security_group_id]
  source_dest_check = false
  tags = {
    Name                      = format("%s-vm02-int-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                     = var.resourceOwner
    f5_cloud_failover_label   = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_cloud_failover_nic_map = "internal"
  }
}

############################ EIPs ############################

# Create Public IPs - mgmt
resource "aws_eip" "vm01-mgmt-pip" {
  vpc               = true
  network_interface = aws_network_interface.vm01-mgmt-nic.id
  tags = {
    Name  = format("%s-vm01-mgmt-pip-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
  depends_on = [aws_network_interface.vm01-mgmt-nic]
}

resource "aws_eip" "vm02-mgmt-pip" {
  vpc               = true
  network_interface = aws_network_interface.vm02-mgmt-nic.id
  tags = {
    Name  = format("%s-vm02-mgmt-pip-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
  depends_on = [aws_network_interface.vm02-mgmt-nic]
}

# Create Public IPs - external
resource "aws_eip" "vm01-ext-pip" {
  vpc                       = true
  network_interface         = aws_network_interface.vm01-ext-nic.id
  associate_with_private_ip = aws_network_interface.vm01-ext-nic.private_ip
  tags = {
    Name  = format("%s-vm01-ext-pip-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
  depends_on = [aws_network_interface.vm01-ext-nic]
}

resource "aws_eip" "vm02-ext-pip" {
  vpc                       = true
  network_interface         = aws_network_interface.vm02-ext-nic.id
  associate_with_private_ip = aws_network_interface.vm02-ext-nic.private_ip
  tags = {
    Name  = format("%s-vm02-ext-pip-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
  depends_on = [aws_network_interface.vm02-ext-nic]
}

# Create Public IPs - VIP
resource "aws_eip" "vip-pip" {
  vpc                       = true
  network_interface         = aws_network_interface.vm01-ext-nic.id
  associate_with_private_ip = local.vm01_vip_ips.app1.ip
  tags = {
    Name                    = format("%s-vip-pip-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                   = var.resourceOwner
    f5_cloud_failover_label = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_cloud_failover_vips  = "${local.vm01_vip_ips.app1.ip},${local.vm02_vip_ips.app1.ip}"
  }
  depends_on = [aws_network_interface.vm01-ext-nic]
}

############################ Compute ############################

# Create F5 BIG-IP VMs

# BIG-IP 1
data "template_file" "onboard_f5vm01" {
  template = file("onboard_f5vm01.tmpl")
  vars = {
    f5_username             = var.f5_username
    f5_password             = random_string.password.result
    f5vm01_mgmt_private_dns = aws_network_interface.vm01-mgmt-nic.private_dns_name
    f5vm01_mgmt_private_ip  = aws_network_interface.vm01-mgmt-nic.private_ip
    f5vm01_ext_private_ip   = aws_network_interface.vm01-ext-nic.private_ip
    f5vm01_int_private_ip   = aws_network_interface.vm01-int-nic.private_ip
    AWSAccessKey            = var.AWSAccessKey
    AWSSecretKey            = var.AWSSecretKey
  }
}

resource "aws_instance" "f5vm01" {
  ami           = data.aws_ami.f5_ami.id
  instance_type = var.ec2_instance_type
  //  key_name             = aws_key_pair.bigip.key_name
  user_data            = data.template_file.onboard_f5vm01.rendered
  iam_instance_profile = aws_iam_instance_profile.bigip_profile.name
  network_interface {
    network_interface_id = aws_network_interface.vm01-mgmt-nic.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.vm01-ext-nic.id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.vm01-int-nic.id
    device_index         = 2
  }
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name  = format("%s-f5vm01-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
}

# BIG-IP 2
data "template_file" "onboard_f5vm02" {
  template = file("onboard_f5vm02.tmpl")
  vars = {
    f5_username             = var.f5_username
    f5_password             = random_string.password.result
    f5vm02_mgmt_private_dns = aws_network_interface.vm02-mgmt-nic.private_dns_name
    f5vm02_mgmt_private_ip  = aws_network_interface.vm02-mgmt-nic.private_ip
    f5vm02_ext_private_ip   = aws_network_interface.vm02-ext-nic.private_ip
    f5vm02_int_private_ip   = aws_network_interface.vm02-int-nic.private_ip
    AWSAccessKey            = var.AWSAccessKey
    AWSSecretKey            = var.AWSSecretKey
  }
}

resource "aws_instance" "f5vm02" {
  ami           = data.aws_ami.f5_ami.id
  instance_type = var.ec2_instance_type
  //  key_name             = aws_key_pair.bigip.key_name
  user_data            = data.template_file.onboard_f5vm02.rendered
  iam_instance_profile = aws_iam_instance_profile.bigip_profile.name
  network_interface {
    network_interface_id = aws_network_interface.vm02-mgmt-nic.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.vm02-ext-nic.id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.vm02-int-nic.id
    device_index         = 2
  }
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name  = format("%s-f5vm02-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
}

############################ Route Table ############################

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = module.aws_network.vpcs["main"]

  route {
    cidr_block           = var.cfe_managed_route
    network_interface_id = aws_network_interface.vm01-ext-nic.id
  }

  tags = {
    Name                    = format("%s-rt-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                   = var.resourceOwner
    f5_cloud_failover_label = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
    f5_self_ips             = "${aws_network_interface.vm01-ext-nic.private_ip},${aws_network_interface.vm02-ext-nic.private_ip}"
  }
}
