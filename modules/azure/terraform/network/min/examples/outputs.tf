output "azureInfra" {
  description = "Azure Vnet and subnet IDs for the created Vnet"
  value = {
    vnetId        = module.network_min.azureVnetId,
    vnetCidrBlock = module.network_min.azureVnetCidr,
    vnetSubnets   = module.network_min.azureSubnets
  }
}