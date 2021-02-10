output "azureInfra" {
  description = "Azure Vnet and subnet IDs for the created Vnet"
  value = {
    vnetId        = module.network.azureVNetId,
    vnetCidrBlock = module.network.azureVnetCidr,
    vnetSubnets   = module.network.azureSubnets
  }
}