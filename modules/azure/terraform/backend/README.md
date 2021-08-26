# Azure Backend

This module will create one Azure Virtual Machine (VM), install docker, and run the (TBD) application. The NIC will reside in the 'private' (aka internal) network, and the VM will have a private IP only.

To use this module within a solutions context:

```hcl
module "backend" {
    source              = "../../../../../azure/terraform/backend/"
    projectPrefix       = "somePrefix"
    buildSuffix         = "someSuffix"
    resourceOwner       = "someName"
    azureResourceGroup  = "someResourceGroup"
    azureLocation       = "westus2"
    ssh_key             = "ssh-rsa AAABC123....."
    subnet              = "someSubnet"
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
| resourceOwner | name of the person or customer running the solution | `string` | n/a | yes |
| securityGroup | security group for virtual machine | `string` | n/a | yes |
| ssh\_key | public key used for authentication in ssh-rsa format | `string` | n/a | yes |
| subnet | subnet for virtual machine | `string` | n/a | yes |
| adminAccountName | admin account name used with instance | `string` | `"ubuntu"` | no |
| instanceType | instance type for virtual machine | `string` | `"Standard_B2ms"` | no |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |
| public\_address | If true, an ephemeral public IP address will be assigned to the webserver.<br>Default value is 'false'. | `bool` | `false` | no |
| user\_data | An optional cloud-config definition to apply to the launched instances. If empty<br>(default), a simple webserver will be launched that displays the hostname of the<br>instance that serviced the request. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| backendInfo | VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine |
| privateIp | private ip address of the instance |
| publicIp | public ip address of the instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
