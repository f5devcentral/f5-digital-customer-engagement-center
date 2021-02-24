output "azureInfra" {
  description = "Azure Vnet and subnet IDs for the created Vnet"
  value = {
    vnetId        = module.network_min.azureVnetId,
    vnetName      = module.network_min.azureVnetName,
    vnetCidrBlock = module.network_min.azureVnetCidr,
    vnetSubnets   = module.network_min.azureSubnets,
    natId         = module.network_min.azureNatId
  }
}