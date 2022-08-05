
resource "random_id" "id" {
  byte_length = 2
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_ssh_public_key" "f5_key" {
  name                = format("%s-pubkey-%s", var.prefix, random_id.id.hex)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = tls_private_key.example.public_key_openssh
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "consumer_vnet" {
  name                = "${var.rg_name}-consumer-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.network_cidr_consumer]
}

resource "azurerm_subnet" "app1Subnet" {
  name                 = "app1Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.consumer_vnet.name
  address_prefixes     = [var.app1_subnet_prefix]
}

#Create NSG and rules for app1Subnet
resource "azurerm_network_security_group" "app1Subnet" {
  name                = format("%s-app1-nsg-%s", var.prefix, random_id.id.hex)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "app1SubnetNSG" {
  for_each                    = var.nsg_rules_ports_app1Subnet
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port
  destination_address_prefix  = "*"
  source_address_prefixes     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.app1Subnet.name
}

resource "azurerm_subnet_network_security_group_association" "app1Subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app1Subnet.id
  network_security_group_id = azurerm_network_security_group.app1Subnet.id
}

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

module "app_server" {
  count               = var.instance_count_app
  source              = "./modules/app_server/"
  vm_name             = "appserver${count.index}"
  f5_ssh_publickey    = azurerm_ssh_public_key.f5_key.public_key
  upassword           = var.upassword
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.app1Subnet.id
}

resource "azurerm_network_interface_backend_address_pool_association" "app_backend_pool_association" {
  count                   = var.instance_count_app
  network_interface_id    = module.app_server[count.index].network_interface_id
  ip_configuration_name   = module.app_server[count.index].ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool.id
}

resource "azurerm_lb" "gateway_lb" {
  name                = "MyGatewayLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Gateway"

  frontend_ip_configuration {
    name      = "myFrontEndGateway"
    subnet_id = azurerm_subnet.provider_vnet_subnets["external"].id
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

resource "azurerm_virtual_network" "provider_vnet" {
  name                = "${var.rg_name}-provider-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.network_cidr]
}

resource "azurerm_subnet" "provider_vnet_subnets" {
  for_each             = var.provider_vnet_subnets_map
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.provider_vnet.name
  address_prefixes     = each.value.address_prefixes
}

#Create NSG and rules for mgmt NIC
resource "azurerm_network_security_group" "mgmt" {
  name                = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "mgmtNSG" {
  for_each                    = var.nsg_rules_ports_mgmt
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port
  destination_address_prefix  = "*"
  source_address_prefixes     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.mgmt.name
}

#
# Create NSG and rules for external NIC
#
resource "azurerm_network_security_group" "external" {
  name                = format("%s-external-nsg-%s", var.prefix, random_id.id.hex)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "externalNSG" {
  for_each                    = var.nsg_rules_ports_external
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port
  destination_address_prefix  = "*"
  source_address_prefixes     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.external.name
}

data "template_file" "init" {
  template = file("${path.module}/f5_onboard.tmpl")
  vars = {
    bigip_password        = var.upassword
    mgmt_gw               = cidrhost(var.provider_vnet_subnets_map.mgmt.address_prefixes[0], 1)
    ext_gw                = cidrhost(var.provider_vnet_subnets_map.external.address_prefixes[0], 1)
    gwlb_frontend_ip      = azurerm_lb.gateway_lb.frontend_ip_configuration[0].private_ip_address
    public_lb_frontend_ip = azurerm_public_ip.public_lb_frontend_ip.ip_address
  }
}

module "bigip" {
  count                      = var.instance_count
  source                     = "./modules/bigip/"
  prefix                     = "bigip"
  f5_ssh_publickey           = azurerm_ssh_public_key.f5_key.public_key
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  mgmt_subnet_ids            = [{ "subnet_id" = azurerm_subnet.provider_vnet_subnets["mgmt"].id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids     = [azurerm_network_security_group.mgmt.id]
  external_subnet_ids        = [{ "subnet_id" = azurerm_subnet.provider_vnet_subnets["external"].id, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids = [azurerm_network_security_group.external.id]
  availabilityZones          = var.availabilityZones
  custom_user_data           = data.template_file.init.rendered
  f5_version                 = var.f5_version
}

resource "azurerm_network_interface_backend_address_pool_association" "gwlb_backend_pool_association" {
  count                   = var.instance_count
  network_interface_id    = module.bigip[count.index].ext_eni_id[0]
  ip_configuration_name   = module.bigip[count.index].ext_eni_ipconfig_name[0]
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_pool_gwlb.id
}
