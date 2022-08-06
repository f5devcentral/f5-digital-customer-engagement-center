
resource "random_id" "buildSuffix" {
  byte_length = 2
}

############################ Locals ############################

locals {
  vnets = {
    consumer = {
      location       = var.location
      addressSpace   = ["192.168.0.0/16"]
      subnetPrefixes = ["192.168.1.0/24"]
      subnetNames    = ["app"]
    }
    provider = {
      location       = var.location
      addressSpace   = ["10.0.0.0/16"]
      subnetPrefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      subnetNames    = ["mgmt", "external", "internal"]
    }
  }
}

############################ Resource Groups ############################

resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg-%s", var.prefix, random_id.buildSuffix.hex)
  location = var.location

  tags = {
    Name      = format("%s-rg-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ Network Security Groups ############################

# Create Mgmt NSG
module "nsg-mgmt" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  security_group_name   = format("%s-nsg-mgmt-%s", var.prefix, random_id.buildSuffix.hex)
  source_address_prefix = [var.adminSrcAddr]

  custom_rules = [
    {
      name                   = "allow_http"
      priority               = "100"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "80"
    },
    {
      name                   = "allow_https"
      priority               = "110"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "443"
    },
    {
      name                   = "allow_ssh"
      priority               = "120"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "22"
    }
  ]

  tags = {
    Name      = format("%s-nsg-mgmt-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Create External NSG
module "nsg-external" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  security_group_name   = format("%s-nsg-external-%s", var.prefix, random_id.buildSuffix.hex)
  source_address_prefix = ["*"]

  custom_rules = [
    {
      name                   = "allow_http"
      priority               = "100"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "80"
    },
    {
      name                   = "allow_https"
      priority               = "110"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "443"
    }
  ]

  tags = {
    Name      = format("%s-nsg-external-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Create Internal NSG
module "nsg-internal" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_group_name = format("%s-nsg-internal-%s", var.prefix, random_id.buildSuffix.hex)

  tags = {
    Name      = format("%s-nsg-internal-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Create App NSG (Consumer)
module "nsg-app" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  security_group_name   = format("%s-nsg-mgmt-%s", var.prefix, random_id.buildSuffix.hex)
  source_address_prefix = [var.adminSrcAddr]

  custom_rules = [
    {
      name                   = "allow_http"
      priority               = "100"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "80"
    },
    {
      name                   = "allow_https"
      priority               = "110"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "443"
    },
    {
      name                   = "allow_ssh"
      priority               = "120"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "22"
    }
  ]

  tags = {
    Name      = format("%s-nsg-app-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ VNets ############################

# Create Provider VNet
module "vnetProvider" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = format("%s-vnetProvider-%s", var.prefix, random_id.buildSuffix.hex)
  address_space       = local.vnets.provider["addressSpace"]
  subnet_prefixes     = local.vnets.provider["subnetPrefixes"]
  subnet_names        = local.vnets.provider["subnetNames"]

  nsg_ids = {
    external = module.nsg-external.network_security_group_id
    internal = module.nsg-internal.network_security_group_id
    mgmt     = module.nsg-mgmt.network_security_group_id
  }

  tags = {
    Name      = format("%s-vnetProvider-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Create Consumer VNet
module "vnetConsumer" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = format("%s-vnetConsumer-%s", var.prefix, random_id.buildSuffix.hex)
  address_space       = local.vnets.consumer["addressSpace"]
  subnet_prefixes     = local.vnets.consumer["subnetPrefixes"]
  subnet_names        = local.vnets.consumer["subnetNames"]

  nsg_ids = {
    app = module.nsg-app.network_security_group_id
  }

  tags = {
    Name      = format("%s-vnetConsumer-%s", var.owner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ Subnet Info ############################

# Retrieve Provider Subnet Data
data "azurerm_subnet" "mgmtSubnet" {
  name                 = "mgmt"
  virtual_network_name = module.vnetProvider.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [module.vnetProvider.vnet_subnets]
}

data "azurerm_subnet" "externalSubnet" {
  name                 = "external"
  virtual_network_name = module.vnetProvider.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [module.vnetProvider.vnet_subnets]
}

data "azurerm_subnet" "internalSubnet" {
  name                 = "internal"
  virtual_network_name = module.vnetProvider.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [module.vnetProvider.vnet_subnets]
}

# Retrieve Provider Subnet Data
data "azurerm_subnet" "appSubnet" {
  name                 = "app"
  virtual_network_name = module.vnetConsumer.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [module.vnetConsumer.vnet_subnets]
}

############################ Azure LB ############################

resource "azurerm_public_ip" "public_lb_frontend_ip" {
  name                = "MyPublicIP"
  sku                 = "Standard"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "public_lb" {
  #the dependency of the app server and bigip is just to ensure that the app server VM's are built and have a chance to run their onboard scripts.
  depends_on = [
    module.app_server,
    module.bigip
  ]
  name                = "MyPublicLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                                               = "myFrontEnd"
    public_ip_address_id                               = azurerm_public_ip.public_lb_frontend_ip.id
    gateway_load_balancer_frontend_ip_configuration_id = azurerm_lb.gateway_lb.frontend_ip_configuration[0].id
  }
}

resource "azurerm_lb_probe" "tcpProbe80" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = "tcpProbe80"
  port            = 80
}

resource "azurerm_lb_probe" "tcpProbe22" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = "tcpProbe22"
  port            = 22
}

resource "azurerm_lb_backend_address_pool" "address_pool" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "rule" {
  for_each                       = toset(var.lb_rules_ports)
  loadbalancer_id                = azurerm_lb.public_lb.id
  name                           = "LBRule${each.value}"
  protocol                       = "Tcp"
  frontend_port                  = each.value
  backend_port                   = each.value
  frontend_ip_configuration_name = "myFrontEnd"
  disable_outbound_snat          = true
  probe_id                       = azurerm_lb_probe.tcpProbe22.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.address_pool.id]
}

resource "azurerm_lb_outbound_rule" "outbound_rule" {
  loadbalancer_id         = azurerm_lb.public_lb.id
  name                    = "OutboundRule"
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool.id

  frontend_ip_configuration {
    name = "myFrontEnd"
  }
}

############################ App Server ############################

module "app_server" {
  count               = var.instance_count_app
  source              = "./modules/app_server/"
  vm_name             = "appserver${count.index}"
  f5_ssh_publickey    = file(var.f5_ssh_publickey)
  upassword           = var.f5_password
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = data.azurerm_subnet.appSubnet.id
}

resource "azurerm_network_interface_backend_address_pool_association" "app_backend_pool_association" {
  count                   = var.instance_count_app
  network_interface_id    = module.app_server[count.index].network_interface_id
  ip_configuration_name   = module.app_server[count.index].ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool.id
}

############################ Azure GWLB ############################

resource "azurerm_lb" "gateway_lb" {
  name                = "MyGatewayLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Gateway"

  frontend_ip_configuration {
    name      = "myFrontEndGateway"
    subnet_id = data.azurerm_subnet.externalSubnet.id
  }
}

resource "azurerm_lb_probe" "gwlbProbe" {
  loadbalancer_id = azurerm_lb.gateway_lb.id
  name            = "tcpProbe80"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

resource "azurerm_lb_backend_address_pool" "address_pool_gwlb" {
  loadbalancer_id = azurerm_lb.gateway_lb.id
  name            = "BackEndAddressPool"
  tunnel_interface {
    identifier = 801
    port       = 2001
    type       = "External"
    protocol   = "VXLAN"
  }
  tunnel_interface {
    identifier = 802
    port       = 2002
    type       = "Internal"
    protocol   = "VXLAN"
  }
}

resource "azurerm_lb_rule" "gwlb_rule" {
  loadbalancer_id                = azurerm_lb.gateway_lb.id
  name                           = "gwlbRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = azurerm_lb.gateway_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.gwlbProbe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.address_pool_gwlb.id]
}

############################ BIG-IP ############################

# Setup Onboarding scripts
locals {
  f5_onboard1 = templatefile("${path.module}/f5_onboard.tmpl", {
    f5_username           = var.f5_username
    f5_password           = var.f5_password
    ssh_keypair           = file(var.f5_ssh_publickey)
    INIT_URL              = var.INIT_URL
    DO_URL                = var.DO_URL
    AS3_URL               = var.AS3_URL
    TS_URL                = var.TS_URL
    FAST_URL              = var.FAST_URL
    DO_VER                = split("/", var.DO_URL)[7]
    AS3_VER               = split("/", var.AS3_URL)[7]
    TS_VER                = split("/", var.TS_URL)[7]
    FAST_VER              = split("/", var.FAST_URL)[7]
    dns_server            = var.dns_server
    ntp_server            = var.ntp_server
    timezone              = var.timezone
    bigIqLicenseType      = var.bigIqLicenseType
    bigIqHost             = var.bigIqHost
    bigIqPassword         = var.bigIqPassword
    bigIqUsername         = var.bigIqUsername
    bigIqLicensePool      = var.bigIqLicensePool
    bigIqSkuKeyword1      = var.bigIqSkuKeyword1
    bigIqSkuKeyword2      = var.bigIqSkuKeyword2
    bigIqUnitOfMeasure    = var.bigIqUnitOfMeasure
    bigIqHypervisor       = var.bigIqHypervisor
    gwlb_frontend_ip      = azurerm_lb.gateway_lb.frontend_ip_configuration[0].private_ip_address
    mgmt_gw               = cidrhost(data.azurerm_subnet.mgmtSubnet.address_prefixes[0], 1)
    ext_gw                = cidrhost(data.azurerm_subnet.externalSubnet.address_prefixes[0], 1)
    public_lb_frontend_ip = azurerm_public_ip.public_lb_frontend_ip.ip_address
  })
}

# Create F5 BIG-IP VMs
module "bigip" {
  count                      = var.instance_count
  source                     = "github.com/F5Networks/terraform-azure-bigip-module"
  prefix                     = var.prefix
  resource_group_name        = azurerm_resource_group.rg.name
  mgmt_subnet_ids            = [{ "subnet_id" = data.azurerm_subnet.mgmtSubnet.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids     = [module.nsg-mgmt.network_security_group_id]
  external_subnet_ids        = [{ "subnet_id" = data.azurerm_subnet.externalSubnet.id, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids = [module.nsg-external.network_security_group_id]
  internal_subnet_ids        = [{ "subnet_id" = data.azurerm_subnet.internalSubnet.id, "public_ip" = false, "private_ip_primary" = "" }]
  internal_securitygroup_ids = [module.nsg-internal.network_security_group_id]
  availability_zone          = var.availability_zone
  f5_ssh_publickey           = file(var.f5_ssh_publickey)
  f5_username                = var.f5_username
  f5_password                = var.f5_password
  f5_instance_type           = var.f5_instance_type
  f5_version                 = var.f5_version
  custom_user_data           = local.f5_onboard1
}

resource "azurerm_network_interface_backend_address_pool_association" "gwlb_backend_pool_association" {
  count                   = var.instance_count
  network_interface_id    = module.bigip[count.index].ext_eni_id[0]
  ip_configuration_name   = module.bigip[count.index].ext_eni_ipconfig_name[0]
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool_gwlb.id
}
