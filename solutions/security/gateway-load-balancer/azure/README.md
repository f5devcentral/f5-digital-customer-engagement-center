# Azure Gateway Load Balancer with BIG-IP
This code deploys Azure Gateway Load Balancer and F5 BIG-IP using Terraform. The BIG-IP will reside in the "Partner VNet" and provide transparent security traffic inspection for traffic entering the customer "Consumer VNet".

## Issues
- Find an issue? Fork, clone, create branch, fix and PR. I'll review and merge into the main branch. Or submit a GitHub issue with all necessary details and logs.

## Diagram

![Architecture](images/Azure-GWLB.png)

## Prerequisites

- Azure CLI
- Terraform
- Azure Subscription
- Azure User with 'Owner' role
- Acceptance of the Azure Marketplace "License/Terms and Conditions" for the images used in this solution
  - BIG-IP image is 200Mb Best, PAYG, v16.1.3.1

```bash
az vm image terms accept --urn f5-networks:f5-big-ip-best:f5-bigip-virtual-edition-200m-best-hourly:16.1.301000
```

## Usage example

- Clone the repo and open the solution's directory

```bash
git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center
cd f5-digital-customer-engagement-center/solutions/security/gateway-load-balancer/azure/
```

- Create the tfvars file and update it with your settings

```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
vi admin.auto.tfvars
```

- Run the setup script to deploy all of the components into your Azure account (remember that you are responsible for the cost of those components)

```bash
./setup.sh
```

## Test your setup
- View the Terraform outputs and find the value for "web_address_for_application"

```bash
terraform output
```

- Browse to the URL to open the demo web app. This traffic is flowing through the BIG-IP Web App Firewall (WAF).
- Review the BIG-IP configuration by accessing the mgmt console (username, password, public IP address from the Terraform output)
- Access the linux vm hosting the demo web app (SSH details from the Terraform output)
- Optionally deploy your own web app that listens on port 80 or 443

## Cleanup
Use the following command to destroy all of the resources

```bash
./destroy.sh
```

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.1.0 |
| azurerm | >= 3 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3 |
| random | n/a |
| template | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| app_server | ./modules/app_server/ |  |
| bigip | ./modules/bigip/ |  |
| nsg-app | Azure/network-security-group/azurerm |  |
| nsg-external | Azure/network-security-group/azurerm |  |
| nsg-internal | Azure/network-security-group/azurerm |  |
| nsg-mgmt | Azure/network-security-group/azurerm |  |
| vnetConsumer | Azure/vnet/azurerm |  |
| vnetProvider | Azure/vnet/azurerm |  |

## Resources

| Name |
|------|
| [azurerm_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) |
| [azurerm_lb_backend_address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) |
| [azurerm_lb_outbound_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) |
| [azurerm_lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) |
| [azurerm_lb_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) |
| [azurerm_network_interface_backend_address_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) |
| [azurerm_network_security_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) |
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| f5\_ssh\_publickey | instance key pair name (e.g. /.ssh/id\_rsa.pub) | `string` | n/a | yes |
| adminSrcAddr | Allowed Admin source IP prefix | `string` | `"0.0.0.0/0"` | no |
| availabilityZones | If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use. | `list(any)` | <pre>[<br>  1<br>]</pre> | no |
| availabilityZones\_public\_ip | The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone. | `string` | `"Zone-Redundant"` | no |
| f5\_instance\_type | Azure instance type to be used for the BIG-IP VE | `string` | `"Standard_DS4_v2"` | no |
| f5\_password | Password for the Virtual Machine | `string` | `"Default12345!"` | no |
| f5\_username | The admin username of the F5 BIG-IP that will be deployed | `string` | `"azureuser"` | no |
| f5\_version | BIG-IP Version | `string` | `"16.1.301000"` | no |
| instance\_count | Number of F5 BIG-IP appliances to deploy behind Gateway Load Balancer | `string` | `"2"` | no |
| instance\_count\_app | Number of demo web app servers to deploy behind public Load Balancer | `string` | `"1"` | no |
| lb\_rules\_ports | List of ports to be opened by LB rules on public-facing LB. | `list(any)` | <pre>[<br>  "22",<br>  "80",<br>  "443"<br>]</pre> | no |
| location | Azure Location of the deployment | `string` | `"westus2"` | no |
| prefix | This value is inserted at the beginning of each Azure object (alpha-numeric, no special character) | `string` | `"demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigip\_mgmt\_public\_ip\_addresses | public ip for bigip mgmt console |
| bigip\_mgmt\_username | username for bigip mgmt console |
| bigip\_password | password for bigip mgmt console |
| ssh\_address\_for\_app\_server | SSH to app server |
| ssh\_username\_for\_app\_server | SSH username for app server |
| web\_address\_for\_application | Public URL to access web app |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->

## How to Contribute

Submit a pull request

# Authors
Michael O'Learly
Mark Ward-Bopp
Jeff Giroux
