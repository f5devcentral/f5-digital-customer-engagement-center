provider "azurerm" {
  features {}
}

############################ Locals for Vnets ############################

locals {
  vnets = {
    transitHub = {
      location       = var.azureLocation
      addressSpace   = ["100.64.96.0/20"]
      subnetPrefixes = ["100.64.96.0/24", "100.64.97.0/24"]
      subnetNames    = ["external", "internal"]
    }
    transitBu11 = {
      location       = var.azureLocation
      addressSpace   = ["100.64.48.0/20"]
      subnetPrefixes = ["100.64.48.0/24", "100.64.49.0/24", "100.64.50.0/24"]
      subnetNames    = ["external", "internal", "workload"]
    }
    transitBu12 = {
      location       = var.azureLocation
      addressSpace   = ["100.64.64.0/20"]
      subnetPrefixes = ["100.64.64.0/24", "100.64.65.0/24", "100.64.66.0/24"]
      subnetNames    = ["external", "internal", "workload"]
    }
    transitBu13 = {
      location       = var.azureLocation
      addressSpace   = ["100.64.80.0/20"]
      subnetPrefixes = ["100.64.80.0/24", "100.64.81.0/24", "100.64.82.0/24"]
      subnetNames    = ["external", "internal", "workload"]
    }
    bu11 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
    bu12 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
    bu13 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
  }
}

############################ Resource Groups ############################

# Create Resource Groups
resource "azurerm_resource_group" "rg" {
  for_each = local.vnets
  name     = format("%s-rg-%s-%s", var.projectPrefix, each.key, random_id.buildSuffix.hex)
  location = each.value["location"]

  tags = {
    Name      = format("%s-rg-%s-%s", var.resourceOwner, each.key, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ VNets ############################

# Create VNets
module "network" {
  for_each            = local.vnets
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  vnet_name           = format("%s-vnet-%s-%s", var.projectPrefix, each.key, random_id.buildSuffix.hex)
  address_space       = each.value["addressSpace"]
  subnet_prefixes     = each.value["subnetPrefixes"]
  subnet_names        = each.value["subnetNames"]

  # nsg_ids = {
  #   external = azurerm_network_security_group.allow_ce[each.key].id
  #   internal = azurerm_network_security_group.allow_ce[each.key].id
  # }

  route_tables_ids = {
    external = azurerm_route_table.rt[each.key].id
    internal = azurerm_route_table.rt[each.key].id
  }

  tags = {
    Name      = format("%s-vnet-%s-%s", var.resourceOwner, each.key, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ Gateway for "Transit Mesh" ############################


############################ VNet Peering - "Transit Mesh" ############################

# Create VNet peering "mesh" between all transit VNets
# 
# This will allow Volterra nodes to route within VNet peering
# versus having to go egress/ingress to internet.
# 
# This hub/spoke method also avoids having to do a
# complete mesh between all transit BU Vnets

locals {
  transitHubPeerings = {
    transitBu11 = {
    }
    transitBu12 = {
    }
    transitBu13 = {
    }
  }
}

# Create transit hub to transit spoke peerings
resource "azurerm_virtual_network_peering" "hubToSpoke" {
  for_each                  = local.transitHubPeerings
  name                      = format("hub-to-%s", each.key)
  resource_group_name       = azurerm_resource_group.rg["transitHub"].name
  virtual_network_name      = module.network["transitHub"].vnet_name
  remote_virtual_network_id = module.network[each.key].vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Create transit spoke to transit hub peerings
resource "azurerm_virtual_network_peering" "spokeToHub" {
  for_each                  = local.transitHubPeerings
  name                      = format("%s-to-hub", each.key)
  resource_group_name       = azurerm_resource_group.rg[each.key].name
  virtual_network_name      = module.network[each.key].vnet_name
  remote_virtual_network_id = module.network["transitHub"].vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}

############################ VNet Peering - BU to Transit ############################

# Create VNet peering between each BU and its transit services
# 
# This will allow clients in the BU VNets to access
# shared services from other BUs via traversing the
# transit peer and landing in the 100.64.x.x shared space.

locals {
  buTransitPeerings = {
    bu11 = {
      name         = "bu11-to-transitBu11"
      remoteVnetId = module.network["transitBu11"].vnet_id
    }
    bu12 = {
      name         = "bu12-to-transitBu12"
      remoteVnetId = module.network["transitBu12"].vnet_id
    }
    bu13 = {
      name         = "bu13-to-transitBu13"
      remoteVnetId = module.network["transitBu13"].vnet_id
    }
    transitBu11 = {
      name         = "transitBu11-to-bu11"
      remoteVnetId = module.network["bu11"].vnet_id
    }
    transitBu12 = {
      name         = "transitBu12-to-bu12"
      remoteVnetId = module.network["bu12"].vnet_id
    }
    transitBu13 = {
      name         = "transitBu13-to-bu13"
      remoteVnetId = module.network["bu13"].vnet_id
    }
  }
}

resource "azurerm_virtual_network_peering" "buToTransit" {
  for_each                  = local.buTransitPeerings
  name                      = each.value["name"]
  resource_group_name       = azurerm_resource_group.rg[each.key].name
  virtual_network_name      = module.network[each.key].vnet_name
  remote_virtual_network_id = each.value["remoteVnetId"]
  allow_forwarded_traffic   = true
}

############################ Route Tables ############################

locals {
  routes = {
    bu11 = {
      nextHop = data.azurerm_network_interface.sliBu11.private_ip_address
    }
    bu12 = {
      nextHop = data.azurerm_network_interface.sliBu12.private_ip_address
    }
    bu13 = {
      nextHop = data.azurerm_network_interface.sliBu13.private_ip_address
    }
    transitBu11 = {
      nextHop = data.azurerm_network_interface.sliBu11.private_ip_address
    }
    transitBu12 = {
      nextHop = data.azurerm_network_interface.sliBu12.private_ip_address
    }
    transitBu13 = {
      nextHop = data.azurerm_network_interface.sliBu13.private_ip_address
    }
  }
}

# Create Route Tables
resource "azurerm_route_table" "rt" {
  for_each                      = local.vnets
  name                          = format("%s-rt-%s-%s", var.projectPrefix, each.key, random_id.buildSuffix.hex)
  location                      = azurerm_resource_group.rg[each.key].location
  resource_group_name           = azurerm_resource_group.rg[each.key].name
  disable_bgp_route_propagation = false

  tags = {
    Name      = format("%s-rt-%s-%s", var.resourceOwner, each.key, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Collect data for Volterra node "inside" NIC
data "azurerm_network_interface" "sliBu11" {
  name                = "master-0-sli"
  resource_group_name = format("%s-bu11-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  depends_on          = [volterra_tf_params_action.applyBu11]
}

data "azurerm_network_interface" "sliBu12" {
  name                = "master-0-sli"
  resource_group_name = format("%s-bu12-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  depends_on          = [volterra_tf_params_action.applyBu12]
}

data "azurerm_network_interface" "sliBu13" {
  name                = "master-0-sli"
  resource_group_name = format("%s-bu13-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  depends_on          = [volterra_tf_params_action.applyBu13]
}

# Create routes
resource "azurerm_route" "rt" {
  for_each               = local.routes
  name                   = "volterra_gateway"
  resource_group_name    = azurerm_resource_group.rg[each.key].name
  route_table_name       = azurerm_route_table.rt[each.key].name
  address_prefix         = "100.64.101.0/24"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = each.value["nextHop"]
}

############################ Security Groups - Jumphost, Web Servers ############################

locals {
  jumphosts = {
    transitHub = {
      subnet = module.network["transitHub"].vnet_subnets[0]
    }
    transitBu11 = {
      subnet = module.network["transitBu11"].vnet_subnets[0]
    }
    transitBu12 = {
      subnet = module.network["transitBu12"].vnet_subnets[0]
    }
    transitBu13 = {
      subnet = module.network["transitBu13"].vnet_subnets[0]
    }
    bu11 = {
      subnet = module.network["bu11"].vnet_subnets[0]
    }
    bu12 = {
      subnet = module.network["bu12"].vnet_subnets[0]
    }
    bu13 = {
      subnet = module.network["bu13"].vnet_subnets[0]
    }
  }

  webservers = {
    bu11 = {
      subnet = module.network["bu11"].vnet_subnets[1]
    }
    bu12 = {
      subnet = module.network["bu12"].vnet_subnets[1]
    }
    bu13 = {
      subnet = module.network["bu13"].vnet_subnets[1]
    }
  }
}

# Allow jumphost access
resource "azurerm_network_security_group" "jumphost" {
  for_each            = local.jumphosts
  name                = format("%s-nsg-jumphost-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name      = format("%s-nsg-jumphost-%s", var.resourceOwner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

# Allow webserver access
resource "azurerm_network_security_group" "webserver" {
  for_each            = local.webservers
  name                = format("%s-nsg-webservers-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_HTTP"
    description                = "Allow HTTP access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name      = format("%s-nsg-webservers-%s", var.resourceOwner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ Compute ############################

# Create jumphost instances
module "jumphost" {
  for_each           = local.jumphosts
  source             = "../../../../modules/azure/terraform/jumphost/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = random_id.buildSuffix.hex
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.rg[each.key].name
  azureLocation      = azurerm_resource_group.rg[each.key].location
  keyName            = var.keyName
  mgmtSubnet         = each.value["subnet"]
  securityGroup      = azurerm_network_security_group.jumphost[each.key].id
}

# Create webserver instances
module "webserver" {
  for_each           = local.webservers
  source             = "../../../../modules/azure/terraform/webServer/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = random_id.buildSuffix.hex
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.rg[each.key].name
  azureLocation      = azurerm_resource_group.rg[each.key].location
  keyName            = var.keyName
  subnet             = each.value["subnet"]
  securityGroup      = azurerm_network_security_group.webserver[each.key].id
}
