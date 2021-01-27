## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminAccountName | admin account | `any` | n/a | yes |
| adminAccountPassword | admin account password | `string` | `""` | no |
| buildSuffix | random build suffix for resources | `string` | `"random-cat"` | no |
| controllerAccount | name of controller admin account | `string` | `""` | no |
| controllerAddress | ip4 address of controller to join | `string` | `"none"` | no |
| controllerPassword | pass of controller admin account | `string` | `""` | no |
| gcpProjectId | gcp project id | `any` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | `"us-east1"` | no |
| gcpZone | zone where gke is deployed | `string` | `"us-east1-b"` | no |
| image | n/a | `string` | `"/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20200810"` | no |
| instanceCount | n/a | `number` | `1` | no |
| instanceSize | n/a | `string` | `"n1-standard-4"` | no |
| nginxCert | cert for nginxplus | `any` | n/a | yes |
| nginxKey | key for nginxplus | `any` | n/a | yes |
| prefix | prefix for resources | `string` | `"demo-nginx"` | no |
| sshPublicKey | body of ssh public key used to access instances | `any` | n/a | yes |
| subnet | subnet to create resource in | `string` | `""` | no |
| tags | n/a | `list` | <pre>[<br>  "nginx"<br>]</pre> | no |
| vpc | vpc network to create resource in | `string` | `""` | no |

## Outputs

No output.
