terraform {
  required_version = ">= 0.14.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.73"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "build_suffix" {
  byte_length = 2
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.projectPrefix, random_id.build_suffix.hex)
  location = var.azureLocation

  tags = {
    Name  = format("%s-rg-%s", var.projectPrefix, random_id.build_suffix.hex)
    Owner = var.resourceOwner
  }
}

# Network Module
module "vnet" {
  source             = "../../network/min"
  projectPrefix      = var.projectPrefix
  buildSuffix        = random_id.build_suffix.hex
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation

  depends_on = [azurerm_resource_group.main]
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "web" {
  name                = format("%s-backend-nsg-%s", var.projectPrefix, random_id.build_suffix.hex)
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
  security_rule {
    name                       = "allow_ssh"
    description                = "Allow SSH access"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name  = format("%s-backend-nsg-%s", var.projectPrefix, random_id.build_suffix.hex)
    Owner = var.resourceOwner
  }
}

module "backend" {
  source             = "../"
  projectPrefix      = var.projectPrefix
  buildSuffix        = random_id.build_suffix.hex
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation
  ssh_key            = var.ssh_key
  subnet             = module.vnet.subnets["private"]
  securityGroup      = azurerm_network_security_group.web.id
  public_address     = true
}
