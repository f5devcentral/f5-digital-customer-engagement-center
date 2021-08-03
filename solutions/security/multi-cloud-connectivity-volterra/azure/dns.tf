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

resource "azurerm_private_dns_a_record" "inside" {
  name                = "inside"
  zone_name           = azurerm_private_dns_zone.sharedAcme.name
  resource_group_name = azurerm_resource_group.rg["bu11"].name
  ttl                 = 300
  records             = ["10.1.52.6"]
}

resource "azurerm_private_dns_cname_record" "sharedAcme" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.sharedAcme.name
  resource_group_name = azurerm_resource_group.rg["bu11"].name
  ttl                 = 300
  record              = "inside.shared.acme.com"
}

############################ DNS Virtual Network Link ############################

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each              = local.vnets
  name                  = each.key
  resource_group_name   = azurerm_resource_group.rg["bu11"].name
  private_dns_zone_name = azurerm_private_dns_zone.sharedAcme.name
  virtual_network_id    = module.network[each.key].vnet_id
}
