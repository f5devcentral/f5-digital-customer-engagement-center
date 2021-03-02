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
}
```

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azureLocation | location where Azure resources are deployed (abbreviated Azure Region name) | `string` | n/a | yes |
| azureResourceGroup | resource group to create objects in | `any` | n/a | yes |
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `any` | n/a | yes |
| azureCidr | VNet CIDR range | `string` | `"10.1.0.0/16"` | no |
| azureSubnets | n/a | <pre>object({<br>    mgmt     = string<br>    external = string<br>    internal = string<br>  })</pre> | <pre>{<br>  "external": "10.1.10.0/24",<br>  "internal": "10.1.20.0/24",<br>  "mgmt": "10.1.1.0/24"<br>}</pre> | no |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| azureNatId | The ID of the NAT Gateway |
| azureVnetCidr | The CIDR block of the VNet |
| azureVnetId | The ID of the Vnet |
| azureVnetName | The Name of the Vnet |
| subnets | A map of subnetworks created by module, keyed by usage context. |
| vpcs | A map of VPC networks created by module, keyed by usage context. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
