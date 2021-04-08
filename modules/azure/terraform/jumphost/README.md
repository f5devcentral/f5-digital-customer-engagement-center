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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
