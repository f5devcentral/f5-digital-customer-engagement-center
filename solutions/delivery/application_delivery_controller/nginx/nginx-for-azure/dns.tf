############################ Private DNS Zones ############################

resource "azurerm_private_dns_zone" "shared" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.shared.name
  tags = {
    Name = format("%s-dns-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Zone Records ############################

resource "azurerm_private_dns_a_record" "appWest" {
  name                = "app1-west"
  zone_name           = azurerm_private_dns_zone.shared.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300
  records             = [azurerm_lb.appWest.private_ip_address]
}

resource "azurerm_private_dns_a_record" "appEast" {
  name                = "app1-east"
  zone_name           = azurerm_private_dns_zone.shared.name
  resource_group_name = azurerm_resource_group.shared.name
  ttl                 = 300
  records             = [azurerm_lb.appEast.private_ip_address]
}

############################ DNS Virtual Network Link ############################

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "shared"
  resource_group_name   = azurerm_resource_group.shared.name
  private_dns_zone_name = azurerm_private_dns_zone.shared.name
  virtual_network_id    = azurerm_virtual_network.shared.id
}
