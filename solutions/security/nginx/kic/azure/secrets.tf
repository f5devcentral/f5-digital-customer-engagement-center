# get current account
data "azurerm_client_config" "current" {
}
# nginx
# create secret
resource "azurerm_key_vault" "nginx" {
  name                = format("%s%s", "kv-nginx", random_id.randomString.dec)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
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
    Owner       = var.resourceOwner
  }
}
# create secret version
resource "azurerm_key_vault_secret" "nginx" {
  name         = format("%s%s", "secret-nginx", random_id.randomString.dec)
  key_vault_id = azurerm_key_vault.nginx.id

  tags = {
    environment = "Dev"
    Owner       = var.resourceOwner
  }
  value = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}"
  }
  EOF
}
