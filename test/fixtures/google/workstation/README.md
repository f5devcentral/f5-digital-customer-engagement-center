# GCP network/min module fixture
<!-- spell-checker: ignore markdownlint -->

This folder contains a fixture for testing the GCP
[network/min](../../../../../modules/google/terraform/network/min/) module.

<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.54 |

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| nat | terraform-google-modules/cloud-router/google | 0.4.0 |
| vpc | terraform-google-modules/network/google | 3.0.1 |
| workstation | ../../../../modules/google/terraform/workstation/ |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where resources are deployed | `string` | n/a | yes |
| image | Image self-link to override default base for VM | `string` | `""` | no |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | n/a | yes |
| users | list of user emails to grant access to workstation | `list(string)` | `[]` | no |
| variant | Workstation variant | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| buildSuffix | Mirror inputs to outputs; allows the test suites inspect Terraform vars regardless of how they were set |
| connection\_helpers | n/a |
| gcpProjectId | n/a |
| gcpRegion | n/a |
| image | n/a |
| projectPrefix | Outputs from the module under test |
| resourceOwner | n/a |
| self\_link | n/a |
| service\_account | n/a |
| subnets | n/a |
| users | n/a |
| vpcs | Inspec |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
