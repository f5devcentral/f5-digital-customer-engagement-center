# GCP network/min module example fixture
<!-- spell-checker: ignore markdownlint -->

This folder contains a fixture for testing the GCP
[network/min](../../../../../modules/google/terraform/network/min/) module example.

<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.54 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | n/a | yes |
| users | list of user emails to grant access to workstation | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| buildSuffix | Mirror inputs to outputs; allows the test suites inspect Terraform vars regardless of how they were set |
| connection\_helpers | n/a |
| gcpProjectId | n/a |
| gcpRegion | n/a |
| projectPrefix | Outputs from the module under test |
| resourceOwner | n/a |
| self\_link | n/a |
| service\_account | n/a |
| subnets | n/a |
| users | n/a |
| vpcs | Inspec - example module does not return this value so send a fake that the controls can use |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
