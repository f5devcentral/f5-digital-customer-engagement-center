output "sharedVnetId" {
  description = "Shared VNet ID"
  value       = azurerm_virtual_network.shared.id
}
output "appWestVnetId" {
  description = "App West Region VNet ID"
  value       = azurerm_virtual_network.appWest.id
}
output "appEastVnetId" {
  description = "App East Region VNet ID"
  value       = azurerm_virtual_network.appEast.id
}
output "sharedSubnetId" {
  description = "Shared Services Subnet ID"
  value       = azurerm_subnet.shared.id
}
output "appWestSubnetId" {
  description = "App West Region Subnet ID"
  value       = azurerm_subnet.appWest.id
}
output "appEastSubnetId" {
  description = "App East Region Subnet ID"
  value       = azurerm_subnet.appEast.id
}
