## k8s
#
# service principal
resource "azuread_application" "k8s" {
  display_name               = format("%s-k8s-sa-%s", var.projectPrefix, random_id.randomString.dec)
  homepage                   = "http://homepage"
  identifier_uris            = ["http://k8s/${format("%s-url-%s", var.projectPrefix, random_id.randomString.dec)}"]
  reply_urls                 = ["http://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "k8s_sp" {
  application_id               = azuread_application.k8s.application_id
  app_role_assignment_required = false

  tags = ["dev", "k8s", "terraform", var.resourceOwner]
}
# Create a Password for  Service Principal
resource "azuread_service_principal_password" "k8s-cs" {
  service_principal_id = azuread_service_principal.k8s_sp.id
  value                = random_password.password.result
  end_date_relative    = "17520h" #expire in 2 years
}
#nginx secret
resource "azurerm_user_assigned_identity" "nginx-sa" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  name = format("%s-nginx-sa-%s", var.projectPrefix, random_id.randomString.dec)
}
