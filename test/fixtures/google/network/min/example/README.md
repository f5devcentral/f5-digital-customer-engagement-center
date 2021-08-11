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
| example | ../../../../../../modules/google/terraform/network/min/example/ |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| buildSuffix | Mirror inputs to outputs; allows the test suites inspect Terraform vars regardless of how they were set |
| gcpProjectId | n/a |
| gcpRegion | n/a |
| projectPrefix | Outputs from the module under test |
| resourceOwner | n/a |
| subnets | n/a |
| vpcs | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
