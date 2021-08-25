provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.projectPrefix, var.buildSuffix)
  location = var.azureLocation
  
  tags = {
    Name  = format("%s-rg-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
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
resource "azurerm_network_security_group" "web" {
  name                = format("%s-backend-nsg-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow_web"
    description                = "Allow Web access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name  = format("%s-backend-nsg-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}

module "backend" {
  source             = "../"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation
  ssh_key            = var.ssh_key
  subnet             = module.azure_network.subnets["private"]
  securityGroup      = azurerm_network_security_group.web.id
}
