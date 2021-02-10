# GCP minimal network

# GCP maximum network

This module will create three [VPC networks](https://cloud.google.com/vpc/docs/vpc) in a single GCE [Region](https://cloud.google.com/compute/docs/regions-zones)
that isolates public facing, private internal/services, and management traffic
for a standard three-leg deployment.

A NAT is included on `mgmt` network to allow BIG-IP and other resources to access
internet.

![gcp-min.png](gcp-min.png)

To use this module within a solutions context:

```hcl
module "network" {
    source = "../../../../../google/terraform/network/max/"
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
| terraform | ~> 0.14.5 |
| google | ~> 3.54 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnets | A map of subnetworks created by module, keyed by usage context. |
| vpcs | A map of VPC networks created by module, keyed by usage context. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
