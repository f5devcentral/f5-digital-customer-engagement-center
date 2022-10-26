############################# Provider ###########################

provider "azurerm" {
  features {}
}

# Create a random id
resource "random_id" "buildSuffix" {
  byte_length = 2
}

############################ Resource Groups ############################

# Create Shared Resource Group
resource "azurerm_resource_group" "shared" {
  name     = format("%s-rg-shared-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location = var.vnets["shared"].location
  tags = {
    Name = format("%s-rg-shared-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create App West Resource Group
resource "azurerm_resource_group" "appWest" {
  name     = format("%s-rg-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location = var.vnets["appWest"].location
  tags = {
    Name = format("%s-rg-appWest-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create App East Resource Group
resource "azurerm_resource_group" "appEast" {
  name     = format("%s-rg-appEast-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location = var.vnets["appEast"].location
  tags = {
    Name = format("%s-rg-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ VNets ############################

# Create Shared VNet
resource "azurerm_virtual_network" "shared" {
  name                = format("%s-vnet-shared-%s", var.projectPrefix, random_id.buildSuffix.hex)
  address_space       = var.vnets["shared"].cidr
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  tags = {
    Name = format("%s-vnet-shared-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create App West VNet
resource "azurerm_virtual_network" "appWest" {
  name                = format("%s-vnet-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  address_space       = var.vnets["appWest"].cidr
  resource_group_name = azurerm_resource_group.appWest.name
  location            = azurerm_resource_group.appWest.location
  tags = {
    Name = format("%s-vnet-appWest-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create App East VNet
resource "azurerm_virtual_network" "appEast" {
  name                = format("%s-vnet-appEast-%s", var.projectPrefix, random_id.buildSuffix.hex)
  address_space       = var.vnets["appEast"].cidr
  resource_group_name = azurerm_resource_group.appEast.name
  location            = azurerm_resource_group.appEast.location
  tags = {
    Name = format("%s-vnet-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Subnets ############################

# Create Shared Subnets
resource "azurerm_subnet" "shared" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.shared.name
  resource_group_name  = azurerm_resource_group.shared.name
  address_prefixes     = var.vnets["shared"].subnetPrefixes
  delegation {
    name = "nginx"
    service_delegation {
      name    = "NGINX.NGINXPLUS/nginxDeployments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Create App West Subnets
resource "azurerm_subnet" "appWest" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.appWest.name
  resource_group_name  = azurerm_resource_group.appWest.name
  address_prefixes     = var.vnets["appWest"].subnetPrefixes
}

# Create App East Subnets
resource "azurerm_subnet" "appEast" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.appEast.name
  resource_group_name  = azurerm_resource_group.appEast.name
  address_prefixes     = var.vnets["appEast"].subnetPrefixes
}

############################ VNet Peering ############################

# Create hub to spoke peerings
resource "azurerm_virtual_network_peering" "hubToAppWest" {
  name                      = "hub-to-appWest"
  resource_group_name       = azurerm_resource_group.shared.name
  virtual_network_name      = azurerm_virtual_network.shared.name
  remote_virtual_network_id = azurerm_virtual_network.appWest.id
}
resource "azurerm_virtual_network_peering" "hubToAppEast" {
  name                      = "hub-to-appEast"
  resource_group_name       = azurerm_resource_group.shared.name
  virtual_network_name      = azurerm_virtual_network.shared.name
  remote_virtual_network_id = azurerm_virtual_network.appEast.id
}

# Create spoke to hub peerings
resource "azurerm_virtual_network_peering" "appWestToHub" {
  name                      = "appWest-to-hub"
  resource_group_name       = azurerm_resource_group.appWest.name
  virtual_network_name      = azurerm_virtual_network.appWest.name
  remote_virtual_network_id = azurerm_virtual_network.shared.id
}
resource "azurerm_virtual_network_peering" "appEastToHub" {
  name                      = "appEast-to-hub"
  resource_group_name       = azurerm_resource_group.appEast.name
  virtual_network_name      = azurerm_virtual_network.appEast.name
  remote_virtual_network_id = azurerm_virtual_network.shared.id
}

############################ Security Groups ############################

# Allow access for Shared Services
resource "azurerm_network_security_group" "shared" {
  name                = format("%s-nsg-shared-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name

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
  security_rule {
    name                       = "allow_HTTPS"
    description                = "Allow HTTPS access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = format("%s-nsg-shared-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Allow access for App West
resource "azurerm_network_security_group" "appWest" {
  name                = format("%s-nsg-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.appWest.location
  resource_group_name = azurerm_resource_group.appWest.name

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
  security_rule {
    name                       = "allow_HTTPS"
    description                = "Allow HTTPS access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = format("%s-nsg-appWest-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Allow access for App East
resource "azurerm_network_security_group" "appEast" {
  name                = format("%s-nsg-appEast-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.appEast.location
  resource_group_name = azurerm_resource_group.appEast.name

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
  security_rule {
    name                       = "allow_HTTPS"
    description                = "Allow HTTPS access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = format("%s-nsg-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Security Groups Association ############################

# Shared NSG association
resource "azurerm_subnet_network_security_group_association" "shared" {
  subnet_id                 = azurerm_subnet.shared.id
  network_security_group_id = azurerm_network_security_group.shared.id
}

# App West NSG association
resource "azurerm_subnet_network_security_group_association" "appWest" {
  subnet_id                 = azurerm_subnet.appWest.id
  network_security_group_id = azurerm_network_security_group.appWest.id
}

# App East NSG association
resource "azurerm_subnet_network_security_group_association" "appEast" {
  subnet_id                 = azurerm_subnet.appEast.id
  network_security_group_id = azurerm_network_security_group.appEast.id
}
