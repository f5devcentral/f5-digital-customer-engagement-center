#outputs
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
output "aks_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}
output "acr_name" {
  value = azurerm_container_registry.acr.name
}
output "acr_login_url" {
  value = azurerm_container_registry.acr.login_server
}
output "secret_id" {
  value = azurerm_key_vault_secret.nginx.id
}
