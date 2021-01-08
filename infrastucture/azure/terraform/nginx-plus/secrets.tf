# nginx
# create secret
resource "azurerm_key_vault" "nginx" {
  name                = format("%s%s", "kv-nginx", random_id.server.hex)
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "premium"
  # terraform account
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    #object_id = data.azurerm_client_config.current.object_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "list"
    ]
  }

  # machine account
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    #object_id = data.azurerm_client_config.current.object_id
    object_id = azurerm_user_assigned_identity.nginx-sa.principal_id
    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "get",
      "list"
    ]
  }

  tags = {
    environment = "Dev"
  }
}
# create secret version
resource "azurerm_key_vault_secret" "nginx" {
  name         = format("%s%s", "secret-nginx", random_id.server.hex)
  key_vault_id = azurerm_key_vault.nginx.id

  tags = {
    environment = "Dev"
  }
  value = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}",
  "cuser": "${var.controllerAccount}",
  "cpass": "${var.controllerPass}"
  }
  EOF
}
##assign secret viewer role
resource "azurerm_role_assignment" "nginx-secrets" {
  scope                = var.resource_group.id
  role_definition_name = "Contributor"
  #principal_id         = azuread_service_principal.nginx_sp.id
  #principal_id         = lookup(azurerm_virtual_machine.nginx.identity[0], "principal_id")
  principal_id = azurerm_user_assigned_identity.nginx-sa.principal_id
}
