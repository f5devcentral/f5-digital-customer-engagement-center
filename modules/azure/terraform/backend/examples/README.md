# Azure backend example
<!-- spell-checker: ignore markdownlint jumphost -->

This example will create backend instances that are simple web servers listening on port 80.

## Usage example

1. Clone the repo and open the module example directory

   ```shell
   git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center
   cd f5-digital-customer-engagement-center/modules/azure/terraform/backend/examples
   ```

2. Copy `admin.auto.tfvars.example` to `admin.auto.tfvars`; edit the values as needed

   ```hcl
   projectPrefix = "demo"
   resourceOwner = "user1"
   azureLocation = "westus2"
   ssh_key       = "ssh-rsa AAABC123....."
   ```

3. Initialize the directory

   ```shell
   terraform init
   ```

4. Validate errors and plan

   ```shell
   terraform validate
   terraform plan
   ```

5. Apply and deploy

   ```shell
   terraform apply -auto-approve
   ```

6. When done with everything, don't forget to clean up!

   ```shell
   terraform destroy -auto-approve
   ```

<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.5 |
| azurerm | >= 2.73 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.73 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azureLocation | location where Azure resources are deployed (abbreviated Azure Region name) | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `string` | n/a | yes |
| ssh\_key | public key used for authentication in ssh-rsa format | `string` | n/a | yes |
| public\_address | If true, an ephemeral public IP address will be assigned to the webserver. Default value is 'false'. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| backendInfo | VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine |
| backendPrivateIp | private ip address of the instance |
| backendPublicIp | public ip address of the instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
