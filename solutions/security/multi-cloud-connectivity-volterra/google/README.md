# GCP multi-cloud component

This module will create a set of Volterra GCP VPC Sites with ingress/egress gateways
configured and a virtual site that spans the CE sites.

> NOTE: only GCP is included in the virtual site currently

HTTP load balancers are advertised on all CE sites that comprise the virtual site,
so existing VMs can use DNS discovery via the Volterra gateways for all virtual
services advertised.

<!-- TODO @memes - images, expand -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.54 |
| volterra | 0.4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.54 |
| random | n/a |
| volterra | 0.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| compute_locations | git::https://github.com/memes/terraform-google-volterra//modules/region-locations?ref=0.3.0 |  |
| hub | terraform-google-modules/network/google | 3.0.1 |
| spoke | terraform-google-modules/network/google | 3.0.1 |
| volterra_sa | git::https://github.com/memes/terraform-google-volterra//modules/service-account?ref=0.2.1 |  |
| webserver_sa | terraform-google-modules/service-accounts/google | 4.0.0 |
| webserver_tls | ../../../../modules/google/terraform/tls |  |
| webservers | ../../../../modules/google/terraform/backend |  |
| workstation | ../../../../modules/google/terraform/workstation |  |

## Resources

| Name |
|------|
| [google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) |
| [google_compute_zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |
| [random_shuffle](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) |
| [volterra_gcp_vpc_site](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/gcp_vpc_site) |
| [volterra_healthcheck](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/healthcheck) |
| [volterra_http_loadbalancer](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/http_loadbalancer) |
| [volterra_origin_pool](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/origin_pool) |
| [volterra_tf_params_action](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/tf_params_action) |
| [volterra_virtual_site](https://registry.terraform.io/providers/volterraedge/volterra/0.4.0/docs/resources/virtual_site) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | `null` | no |
| business\_units | The set of VPCs to create with overlapping CIDRs. | <pre>map(object({<br>    cidr = string<br>    mtu  = number<br>  }))</pre> | <pre>{<br>  "bu21": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460<br>  },<br>  "bu22": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460<br>  },<br>  "bu23": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460<br>  }<br>}</pre> | no |
| domain\_name | The DNS domain name that will be used as common parent generated DNS name of<br>loadbalancers. | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | n/a | yes |
| hub\_cidr | n/a | `string` | `"100.64.96.0/20"` | no |
| labels | An optional list of labels to apply to GCP resources. | `map(string)` | `{}` | no |
| num\_servers | The number of webserver instances to launch in each business unit spoke. Default<br>is 2. | `number` | `2` | no |
| num\_volterra\_nodes | The number of Volterra gateway instances to launch in each business unit spoke.<br>Default is 1. | `number` | `1` | no |
| projectPrefix | prefix for resources | `string` | `"demo"` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| volterra\_namespace | The Volterra namespace into which Volterra resources will be managed. | `string` | n/a | yes |
| volterra\_ssh\_key | An optional SSH key to add to Volterra nodes. | `string` | `""` | no |
| volterra\_tenant | The Volterra tenant to use. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connection\_helpers | A set of `gcloud` commands to connect to SSH, setup a forward-proxy, and to access<br>Code Server on the workstation. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
