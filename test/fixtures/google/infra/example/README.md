# GCP infra module fixture
<!-- spell-checker: ignore markdownlint -->

This folder contains a fixture for testing the GCP
[infra](../../../../../modules/google/terraform/nifra/) module.

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
| expected\_main\_equiv | Expected main VPC equivalent | `string` | `"mgmt"` | no |
| features | Behavioural features to supply to infra module | <pre>object({<br>    workstation = bool<br>    isolated    = bool<br>    registry    = bool<br>  })</pre> | <pre>{<br>  "isolated": false,<br>  "registry": false,<br>  "workstation": true<br>}</pre> | no |
| labels | Optional labels to add in addition to those set by infra | `map(string)` | `{}` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| users | list of user emails to grant access to workstation | `list(string)` | `[]` | no |
| vpc\_options | VPC features to supply to infra module | <pre>object({<br>    mgmt = object({<br>      primary_cidr = string<br>      mtu          = number<br>      nat          = bool<br>    })<br>    private = object({<br>      primary_cidr = string<br>      mtu          = number<br>      nat          = bool<br>    })<br>    public = object({<br>      primary_cidr = string<br>      mtu          = number<br>      nat          = bool<br>    })<br>  })</pre> | <pre>{<br>  "mgmt": {<br>    "mtu": 1460,<br>    "nat": true,<br>    "primary_cidr": "10.0.10.0/24"<br>  },<br>  "private": {<br>    "mtu": 1460,<br>    "nat": false,<br>    "primary_cidr": "10.0.20.0/24"<br>  },<br>  "public": {<br>    "mtu": 1460,<br>    "nat": false,<br>    "primary_cidr": "10.0.30.0/24"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| buildSuffix | Mirror inputs to outputs; allows the test suites inspect Terraform vars regardless of how they were set |
| expected\_main\_equiv | n/a |
| features | n/a |
| gcpProjectId | n/a |
| gcpRegion | n/a |
| projectPrefix | Outputs from the module under test |
| registries | n/a |
| resourceOwner | n/a |
| subnets | n/a |
| users | n/a |
| vpc\_options | n/a |
| vpcs | n/a |
| workstation | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
