output "azureInfra" {
  description = "Azure Vnet and subnet IDs for the created Vnet"
  value = {
    vnetId        = module.azure_network.azureVnetId,
    vnetName      = module.azure_network.azureVnetName,
    vnetCidrBlock = module.azure_network.azureVnetCidr,
    natId         = module.azure_network.azureNatId,
    vpcs          = module.azure_network.vpcs,
    subnets       = module.azure_network.subnets
  }
}
