# Azure Network

This module will create one Azure Virtual Network (VNet) that isolates public facing, private internal/services, and management traffic for a three-leg deployment.

A NAT is included on `mgmt` network to allow BIG-IP and other resources to access internet.

![azure-network.png](azure-network.png)

To use this module within a solutions context:

```hcl
module "network_min" {
    source              = "../../../../../azure/terraform/network/min/"
    projectPrefix       = var.projectPrefix
    buildSuffix         = var.buildSuffix
    resourceOwner       = var.resourceOwner
    azureResourceGroup  = var.azureResourceGroup
    azureLocation       = var.azureLocation
    azureCidr           = var.azureCidr
    azureSubnets        = var.azureSubnets
}
```

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| azurerm | ~> 2.48 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| projectPrefix | prefix for resources | `string` | `"demo"` | no |
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `string` | n/a | yes |
| azureResourceGroup | resource group to create objects in | `string` | n/a | yes |
| azureLocation | location where Azure resources are deployed (abbreviated Azure Region name) | `string` | n/a | yes |
| azureCidr | VNet CIDR range | `string` | `"10.1.0.0/16"` | no |
| azureSubnets | subnets to create within the VNet | `object` | `management = "10.1.1.0/24"`<br>`external = "10.1.10.0/24"`<br>`internal = "10.1.20.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| azureVnetId | The ID of the Vnet |
| azureVnetName | The Name of the Vnet |
| azureVnetCidr | The CIDR block of the VNet |
| azureSubnets | List of IDs of subnets |
| azureNatId | The ID of the NAT Gateway |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->