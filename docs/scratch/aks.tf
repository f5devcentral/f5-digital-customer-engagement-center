# aks
# https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
# resource azurerm_resource_group k8s {
#   name     = var.aksResourceName
#   location = var.location
# }
#
resource "azurerm_kubernetes_cluster" "k8s" {
  count               = var.kubernetes ? 1 : 0
  name                = var.aksClusterName
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aksDnsPrefix
  default_node_pool {
    name       = "default"
    node_count = var.aksAgentNodeCount
    vm_size    = var.aksInstanceSize
  }
  identity {
    type = "SystemAssigned"
  }
  service_principal {
    client_id     = azuread_service_principal.k8s_sp.application_id
    client_secret = random_password.password.result # this is set in secrets
  }
}
