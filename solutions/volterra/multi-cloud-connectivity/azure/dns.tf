############################ Private DNS Zones ############################

resource "azurerm_private_dns_zone" "sharedAcme" {
  for_each            = local.vnets
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.rg[each.key].name

  tags = {
    Name      = format("%s-dns-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ Zone Records ############################

resource "azurerm_private_dns_a_record" "inside" {
  for_each            = local.vnets
  name                = "inside"
  zone_name           = azurerm_private_dns_zone.sharedAcme[each.key].name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  ttl                 = 300
  records             = [data.azurerm_network_interface.sli[each.key].private_ip_address]
}

resource "azurerm_private_dns_cname_record" "sharedAcme" {
  for_each            = local.vnets
  name                = "*"
  zone_name           = azurerm_private_dns_zone.sharedAcme[each.key].name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  ttl                 = 300
  record              = format("inside.%s", var.domain_name)
}

############################ DNS Virtual Network Link ############################

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each              = local.vnets
  name                  = each.key
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  private_dns_zone_name = azurerm_private_dns_zone.sharedAcme[each.key].name
  virtual_network_id    = module.network[each.key].vnet_id
}
