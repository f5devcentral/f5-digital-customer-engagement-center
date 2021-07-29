# Set locals
locals {
  dnsRecords = {
    bu11 = {
      name    = "bu11app"
      records = ["100.64.101.110"]
      vnetId  = module.network["bu11"].vnet_id
    }
    bu12 = {
      name    = "bu12app"
      records = ["100.64.101.120"]
      vnetId  = module.network["bu12"].vnet_id
    }
    bu13 = {
      name    = "bu13app"
      records = ["100.64.101.130"]
      vnetId  = module.network["bu13"].vnet_id
    }
  }
}

############################ Private DNS Zones ############################

resource "azurerm_private_dns_zone" "sharedAcme" {
  name                = "shared.acme.com"
  resource_group_name = azurerm_resource_group.rg["bu11"].name

  tags = {
    Name      = format("%s-dns-%s", var.resourceOwner, random_id.buildSuffix.hex)
    Terraform = "true"
  }
}

############################ Zone Records ############################

resource "azurerm_private_dns_a_record" "app" {
  for_each            = local.dnsRecords
  name                = each.value["name"]
  zone_name           = azurerm_private_dns_zone.sharedAcme.name
  resource_group_name = azurerm_resource_group.rg["bu11"].name
  ttl                 = 300
  records             = each.value["records"]
}

############################ DNS Virtual Network Link ############################

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each              = local.dnsRecords
  name                  = each.key
  resource_group_name   = azurerm_resource_group.rg["bu11"].name
  private_dns_zone_name = azurerm_private_dns_zone.sharedAcme.name
  virtual_network_id    = each.value["vnetId"]
}
