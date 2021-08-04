# Multi-cloud Volterra demo

<!-- spell-checker: ignore volterra markdownlint tfvars -->
This module will create a set of Volterra AWS VPC, Azure VNET, and GCP VPC Sites
with ingress/egress gateways configured and a virtual site that spans the cloud
sites.

![multi-cloud-volterra-hla.png](images/multi-cloud-volterra-hla.png)
<!-- markdownlint-disable no-inline-html -->
<p align="center">Figure 1: High-level overview of solution; this modu</p>
<!-- markdownlint-enable no-inline-html -->

HTTP load balancers are created for each business unit service, and are advertised
on every CE site that match the selector predicate for the Virtual Site. This means
that existing resources can use DNS discovery via the Volterra gateways without
changing the deployment.

> See [Scenario](SCENARIO.md) document for details on why this solution was chosen
> for a hypothetical customer looking for a minimally invasive solution
> to multi-cloud networking.

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.5 |
| aws | >= 3.0 |
| azurerm | >= 2.69 |
| google | >= 3.77 |
| volterra | 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| google | ./google/ |  |

## Resources

| Name |
|------|
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| volterraTenant | The Volterra tenant to use. | `string` | n/a | yes |
| volterra\_namespace | The Volterra namespace into which Volterra resources will be managed. | `string` | n/a | yes |
| awsRegion | aws region | `string` | `null` | no |
| azureLocation | location where Azure resources are deployed (abbreviated Azure Region name) | `string` | `null` | no |
| buildSuffix | unique build suffix for resources; will be generated if empty or null | `string` | `null` | no |
| domain\_name | The DNS domain name that will be used as common parent generated DNS name of<br>loadbalancers. Default is 'shared.acme.com'. | `string` | `"shared.acme.com"` | no |
| gcpProjectId | gcp project id | `string` | `null` | no |
| gcpRegion | region where GCP resources will be deployed | `string` | `null` | no |
| projectPrefix | prefix for resources | `string` | `"mcn-demo"` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| ssh\_key | An optional SSH key to add to nodes. | `string` | `""` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
