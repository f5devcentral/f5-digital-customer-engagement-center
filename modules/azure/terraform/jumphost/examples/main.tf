provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.projectPrefix, var.buildSuffix)
  location = var.azureLocation

  tags = {
    Name      = format("%s-rg-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Network Module
module "azure_network" {
  source             = "../../network/min"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation

  depends_on = [azurerm_resource_group.main]
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "mgmt" {
  name                = format("%s-jumphost-nsg-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  resource_group_name = azurerm_resource_group.main.name

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
    Name      = format("%s-jumphost-nsg-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

module "jumphost" {
  source             = "../"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation
  keyName            = var.keyName
  mgmtSubnet         = module.azure_network.subnets["mgmt"]
  securityGroup      = azurerm_network_security_group.mgmt.id
}
