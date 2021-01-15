provider "azurerm" {
  // public, usgovernment, german, and china. Defaults to public
  environment = "public"
  features {}
}
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}_rg_${random_pet.buildSuffix.id}"
  location = var.location
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

// Network
module "azure_network" {
  source         = "../../../../../../infrastucture/azure/terraform/network/min"
  resource_group = azurerm_resource_group.main
  buildSuffix    = random_pet.buildSuffix.id
}

// Nginx
module "nginx" {
  source           = "../../../../../../infrastucture/azure/terraform/nginx-plus"
  resource_group   = azurerm_resource_group.main
  nginxCert        = var.nginxCert
  nginxKey         = var.nginxKey
  buildSuffix      = random_pet.buildSuffix.id
  subnet           = module.azure_network.subnets["mgmt"]
  adminPassword    = random_password.password.result
  adminAccountName = var.adminAccountName
  sshPublicKey     = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
}
