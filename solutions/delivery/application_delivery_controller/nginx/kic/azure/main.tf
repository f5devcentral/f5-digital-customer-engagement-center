
provider "azurerm" {
  alias = "azure"
  // public, usgovernment, german, and china. Defaults to public
  environment = "public"
  features {}
}

module "azure" {
  count      = 0
  source     = "../../../../../../modules/azure/terraform/network/min"
  kubernetes = true
  providers = {
    azurerm = azurerm.azure
  }
}


// module nginx {
//   source = "./nginx"
//   vpc = module.infa.vpc_nginx.id
//   subnets = [module.infa.subnet1.id, modules.ifra.subnet2.id]
//   admin_cidr

// }

// module controller {
//   vpc = module.infa.vpc_controller.id
//   subnets = [module.infa.subnet1.id, modules.]
// }
