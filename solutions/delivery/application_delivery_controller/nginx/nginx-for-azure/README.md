# F5 NGINX for Azure Deployment with Demo Application in Multiple Regions

## To Do

- Add F5 NGINX for Azure Terraform code (TBD...waiting for GA release)

## Issues

- Find an issue? Fork, clone, create branch, fix and PR. I'll review and merge into the main branch. Or submit a GitHub issue with all necessary details and logs.

## Contents

- [Introduction](#introduction)
- [Configuration Example](#configuration-example)
- [Requirements](#requirements)
- [Installation Example](#installation-example)
- [CI/CD Pipeline NGINX Config with Azure Functions](#cicd-pipeline-nginx-config-with-azure-functions)
- [Monitor and Metrics](#monitor-and-metrics)
- [Troubleshooting](#troubleshooting)

## Introduction

This solution will create an [F5 NGINX for Azure](https://docs.nginx.com/nginx-for-azure) deployment and a set of Azure VNets for a demo application hosted in multiple Azure regions. The application will be running in the West and East regions, and NGINX will provide traffic management, security, and high availability across regions.

The resulting deployment will consist of the following:

- F5 Dataplane Subscription (SaaS)
  - NGINX for Azure deployment
  - Note: hidden, user will not see this
- Shared VNet and subnets (customer Hub)
  - NGINX eNICs for [VNet injection](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-for-azure-services)
  - Azure Function App with PowerShell code
  - NGINX metrics published to Azure Monitor
- Application VNet and subnets (customer Spoke)
  - 1x App VNet in West region
  - 1x App VNet in East region
  - VM Scale Sets for each region
- VNet peering
  - Hub to/from App-West VNet
  - Hub to/from App-East VNet

## Configuration Example

The following is an example configuration diagram for this solution deployment.

![F5 NGINX for Azure](./images/nginx-multiple-region.png)

## Requirements

- Azure CLI
- Terraform
- Azure User with 'Owner' role to deploy resources
- [Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) to associate with NGINX deployment (monitoring, key vault)
  - Note: if not supplied, one will be created

## Installation Example

- Clone the repo and open the solution's directory
```bash
git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center
cd f5-digital-customer-engagement-center/solutions/delivery/application_delivery_controller/nginx/nginx-for-azure/
```

- Create the tfvars file and update it with your settings
```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
vi admin.auto.tfvars
```

**Note:**  `projectPrefix` can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long.

- Run the setup script:
```bash
./setup.sh
```

## Test your setup:

1. Copy the public IP from the NGINX Deployment. This value can also be found in Terraform outputs as 'public_IP_nginx'.

![NGINX IP address](images/nginx-ip-address.png)

2. On your laptop/PC, open a browser to public IP address.

Note: Depending on health checks and client request, you will either get the "West" or "East" application servers.

![Demo App Region](images/test-site.png)

3. Manually choose the West region by browsing to the /west URL path.

![Demo App West Region](images/test-site-west.png)

4. Manually choose the East region by browsing to the /east URL path.

![Demo App East Region](images/test-site-east.png)

## CI/CD Pipeline NGINX Config with Azure Functions

The nginx.conf in this demo contains URL path routing and multiple upstream selections. The configuration is sourced from the Azure Function PowerShell file found in [function-app/vmAutoscaleNginxConfig/vmssFunction.ps1](function-app/vmAutoscaleNginxConfig/vmssFunction.ps1). The VMSS groups send HTTP triggers via webhook notify messages for each autoscale event, and the nginx.conf is dynamically generated and applied to NGINX. You can also modify the nginx.conf portion in the vmssFunction.ps1 file and reapply Terraform.

### Example Workflow #1: Scale In/Out Event
1. VMSS scale in/out event occurs
2. VMSS webhook notify sent to Azure Function HTTP trigger
3. vmssFunction.ps1 collects VM IP addresses, builds nginx.conf
4. Lastly, vmssFunction.ps1 updates NGINX via ARM deployment

### Example Workflow #2: Modify nginx.conf in vmssFunction.ps1
1. User has a requirement to add rate limiting
2. Manually edit [function-app/vmAutoscaleNginxConfig/vmssFunction.ps1](function-app/vmAutoscaleNginxConfig/vmssFunction.ps1)
3. Locate the nginx.conf portion and update with rate limiting directives (see [Rate Limiting](https://docs.nginx.com/nginx-for-azure/management/rate-limiting/))
4. Save vmssFunction.ps1
5. Lastly, reapply Terraform to push the config

Note: Make sure to place a PowerShell escape character ` before the $binary_remote_addr. Otherwise PowerShell will treat it like a variable and try to render the value and fail.

```
# Example nginx.conf
http {
  limit_req_zone `$binary_remote_addr zone=mylimit:10m rate=1r/s;

  upstream app1 {
    server 10.100.0.5:80;
    server 10.101.0.5:80 backup;
  }
  upstream app1-west {
    server 10.100.0.5:80;
  }
  upstream app1-east {
    server 10.101.0.5:80;
  }

  server {
    listen 80 default_server;
    location / {
      proxy_pass http://app1/;
      limit_req zone=mylimit;
    }
    location /west/ {
      proxy_pass http://app1-west/;
    }
    location /east/ {
      proxy_pass http://app1-east/;
    }
  }

}
```

## Cleanup
- Run the solution destroy script:
```bash
./destroy.sh
```

## Monitor and Metrics
This demo automatically associates a managed identity to the NGINX deployment and enables diagnostics. NGINX will publish application telemetry data to Azure Monitor, and you can review/analyze/alert on those metrics. See [Enable NGINX for Azure Monitoring](https://docs.nginx.com/nginx-for-azure/monitoring/enable-monitoring/) for more info.

![NGINX Azure Monitor Metrics Explorer](./images/nginx-metrics-explorer.png)

## Troubleshooting

### Serial Logs of Application Servers (upstreams)
Review the serial logs for the Azure virtual machine. Login to the Azure portal, open "Virtual Machines", then locate your instance...click it. Hit Serial Console. Then review the serial logs for errors.

### NGINX for Azure
Review the NGINX deployment logs and contact support. See the links below...
- [Troubleshooting NGINX for Azure](https://docs.nginx.com/nginx-for-azure/troubleshooting/troubleshooting/)
- [FAQ](https://docs.nginx.com/nginx-for-azure/troubleshooting/faq/)

### Traffic Flows
Review the high level diagram to see the architecture and understand traffic flows. If the NGINX deployment cannot access the application upstream servers, then please validate there arethe necessary Network Seurity Group rules, VNet peering, and DNS entries.

## How to Contribute

Submit a pull request

# Authors
- Jeff Giroux


<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.0 |
| azurerm | >= 3 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| azurerm | >= 3 |
| null | n/a |
| random | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [archive_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) |
| [azurerm_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) |
| [azurerm_function_app_host_keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/function_app_host_keys) |
| [azurerm_linux_virtual_machine_scale_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) |
| [azurerm_monitor_autoscale_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) |
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) |
| [azurerm_resource_group_template_deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) |
| [azurerm_virtual_network_peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) |
| [azurerm_windows_function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `string` | n/a | yes |
| sshPublicKey | public key used for authentication in ssh-rsa format | `string` | n/a | yes |
| adminName | admin account name used with app server instance | `string` | `"azureuser"` | no |
| enableMetrics | Enable publishing metrics data from NGINX deployment | `bool` | `true` | no |
| numServers | number of app server instances to launch in each autoscale group | `number` | `1` | no |
| userAssignedIdentityId | The resource ID of the user-assigned managed identity associated to the NGINX deployment resource. If one is not supplied, a user identity resource will automatically be created. | `string` | `null` | no |
| vnets | The set of VNets to create | <pre>map(object({<br>    cidr           = list(any)<br>    subnetPrefixes = list(any)<br>    subnetNames    = list(any)<br>    location       = string<br>  }))</pre> | <pre>{<br>  "appEast": {<br>    "cidr": [<br>      "10.101.0.0/16"<br>    ],<br>    "location": "eastus2",<br>    "subnetNames": [<br>      "default"<br>    ],<br>    "subnetPrefixes": [<br>      "10.101.0.0/24"<br>    ]<br>  },<br>  "appWest": {<br>    "cidr": [<br>      "10.100.0.0/16"<br>    ],<br>    "location": "westus2",<br>    "subnetNames": [<br>      "default"<br>    ],<br>    "subnetPrefixes": [<br>      "10.100.0.0/24"<br>    ]<br>  },<br>  "shared": {<br>    "cidr": [<br>      "10.255.0.0/16"<br>    ],<br>    "location": "eastus2",<br>    "subnetNames": [<br>      "default"<br>    ],<br>    "subnetPrefixes": [<br>      "10.255.0.0/24"<br>    ]<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_IP\_nginx | Public IP address of the NGINX deployment |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
