# GCP backend
<!-- spell-checker: ignore markdownlint -->

This module will create backend instances that are simple web servers, listening
on port 80 (and 443 if a TLS Secret Manager key is provided).

<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.5 |
| google | >= 3.54 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.54 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| subnet | Self-link of the subnet that the workstation should be attached to. | `string` | n/a | yes |
| disk\_size\_gb | Use this flag to set the boot volume size in GB. Default is 50Gb. | `number` | `50` | no |
| disk\_type | The boot disk type to use with instances; can be 'pd-balanced' (default),<br>'pd-ssd', or 'pd-standard'. | `string` | `"pd-balanced"` | no |
| image | An optional Google Compute Engine image to use instead of the module default (COS).<br>Set this to use a specific image; see also `user_data` to set cloud-config. | `string` | `null` | no |
| labels | An optional map of key:value strings that will be applied to resources as labels,<br>where supported. | `map(string)` | `{}` | no |
| machine\_type | The compute machine type to use for workstation VM. Default is 'e2-standard-4'<br>which provides 4 vCPUs and 16Gb RAM, and is available in all regions. | `string` | `"e2-standard-4"` | no |
| name | The name to assign to the server VM. If left empty(default), a name will be<br>generated as '{projectPrefix}-server-{buildSuffix}' where {projectPrefix}<br>and {buildSuffix} will be the values of the respective variables. | `string` | `null` | no |
| preemptible | If set to true, the workstation will be deployed on preemptible VMs which<br>could be terminated at any time, and have a maximum lifetime of 24 hours. Default<br>value is false. | `string` | `false` | no |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |
| public\_address | If true, an ephemeral public IP address will be assigned to the webserver.<br>Default value is 'false'. | `bool` | `false` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| service\_account | The service account to use with server. If empty (default), the Default Compute<br>service account will be used. | `string` | `null` | no |
| tags | An optional list of network tags to apply to the instance; default is an empty set. | `list(string)` | `[]` | no |
| tls\_secret\_key | An optional Secret Manager key that contains a TLS certificate and key pair that<br>will be used for the backend server. If empty (default), the backend server will<br>listen on port 80 only unless a custom `user_data` is provided. | `string` | `""` | no |
| user\_data | An optional cloud-config definition to apply to the launched instances. If empty<br>(default), a simple webserver will be launched that displays the hostname of the<br>instance that serviced the request. | `string` | `null` | no |
| zone | The Compute Zone where the server will be deployed. If empty (default), instances<br>will be randomly assigned from zones in the subnet region. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| addresses | The private IP address and public IP address assigned to the instance. |
| self\_link | The fully-qualifed self-link of the webserver instance. |
| service\_account | The service account used by the server instances. |
| zone | The list of zone where the server is deployed. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
