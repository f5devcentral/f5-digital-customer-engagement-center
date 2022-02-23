output network_interface_id {
  value = azurerm_network_interface.nic.id
}

output ip_configuration_name  {
  value = azurerm_network_interface.nic.ip_configuration[0].name
}