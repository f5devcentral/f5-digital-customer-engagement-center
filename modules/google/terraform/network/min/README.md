# GCP minimal network

This module will create three VPC networks in a single GCE [Region] that isolates
public facing, private internal/services, and management traffic.

![gcp-min.png](gcp-min.png)

To use this module within a solutions context:

```hcl
module "network_min" {
    source = "../../../../../google/terraform/network/min/"
    gcpProjectId = var.gcpProjectId
    gcpRegion = var.gcpRegion
    projectPrefix = var.projectPrefix
    buildSuffix = var.buildSuffix
}
```

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | > 0.12 |
| google | ~> 3.54 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `any` | n/a | yes |
| gcpProjectId | gcp project id | `any` | n/a | yes |
| gcpRegion | region where gke is deployed | `any` | n/a | yes |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnets | A map of subnetworks created by module, keyed by usage context. |
| vpcs | A map of VPC networks created by module, keyed by usage context. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
