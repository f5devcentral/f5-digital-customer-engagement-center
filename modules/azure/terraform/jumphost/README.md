# Azure Jumphost

This module will create one Azure Virtual Machine (VM) with one network interface.

To use this module within a solutions context:

```hcl
module "jumphost" {
    source              = "../../../../../azure/terraform/jumphost/"
    projectPrefix       = "somePrefix"
    buildSuffix         = "someSuffix"
    resourceOwner       = "someName"
    azureResourceGroup  = "someResourceGroup"
    azureLocation       = "westus2"
    keyName             = "~/.ssh/id_rsa.pub"
    mgmtSubnet          = "someSubnet"
    securityGroup       = "someSecurityGroup"
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
| azureResourceGroup | resource group to create objects in | `string` | n/a | yes |
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| keyName | instance key pair name | `string` | n/a | yes |
| mgmtSubnet | subnet for virtual machine | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `string` | n/a | yes |
| securityGroup | security group for virtual machine | `string` | n/a | yes |
| adminAccountName | admin account name used with instance | `string` | `"ubuntu"` | no |
| coderAccountPassword | n/a | `string` | `"pleaseUseVault123!!"` | no |
| instanceType | instance type for virtual machine | `string` | `"Standard_DS3_v2"` | no |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |
| repositories | comma seperated list of git repositories to clone | `string` | `""` | no |
| terraformVersion | n/a | `string` | `"0.14.10"` | no |

## Outputs

| Name | Description |
|------|-------------|
| jumphostInfo | VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine |
| publicIp | public ip address of the instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
