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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.77 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.77.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | 0.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute_locations"></a> [compute\_locations](#module\_compute\_locations) | git::https://github.com/memes/terraform-google-volterra//modules/region-locations | 0.3.0 |
| <a name="module_dns"></a> [dns](#module\_dns) | terraform-google-modules/cloud-dns/google | 3.1.0 |
| <a name="module_inside"></a> [inside](#module\_inside) | terraform-google-modules/network/google | 3.0.1 |
| <a name="module_outside"></a> [outside](#module\_outside) | terraform-google-modules/network/google | 3.0.1 |
| <a name="module_volterra_sa"></a> [volterra\_sa](#module\_volterra\_sa) | git::https://github.com/memes/terraform-google-volterra//modules/service-account | 0.2.1 |
| <a name="module_webserver_sa"></a> [webserver\_sa](#module\_webserver\_sa) | terraform-google-modules/service-accounts/google | 4.0.0 |
| <a name="module_webserver_tls"></a> [webserver\_tls](#module\_webserver\_tls) | ../../../../modules/google/terraform/tls | n/a |
| <a name="module_webservers"></a> [webservers](#module\_webservers) | ../../../../modules/google/terraform/backend | n/a |
| <a name="module_workstation"></a> [workstation](#module\_workstation) | ../../../../modules/google/terraform/workstation | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.inside](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [random_id.build_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_shuffle.zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [volterra_gcp_vpc_site.inside](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/gcp_vpc_site) | resource |
| [volterra_healthcheck.inside](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/healthcheck) | resource |
| [volterra_http_loadbalancer.inside](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/http_loadbalancer) | resource |
| [volterra_origin_pool.inside](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/origin_pool) | resource |
| [volterra_tf_params_action.inside](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/tf_params_action) | resource |
| [volterra_virtual_site.site](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/virtual_site) | resource |
| [google_compute_instance.inside](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_instance) | data source |
| [google_compute_region_instance_group.inside](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_region_instance_group) | data source |
| [google_compute_zones.zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buildSuffix"></a> [buildSuffix](#input\_buildSuffix) | random build suffix for resources | `string` | `null` | no |
| <a name="input_business_units"></a> [business\_units](#input\_business\_units) | The set of VPCs to create with overlapping CIDRs. | <pre>map(object({<br>    cidr        = string<br>    mtu         = number<br>    workstation = bool<br>  }))</pre> | <pre>{<br>  "bu21": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": true<br>  },<br>  "bu22": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": false<br>  },<br>  "bu23": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": false<br>  }<br>}</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The DNS domain name that will be used as common parent generated DNS name of<br>loadbalancers. | `string` | n/a | yes |
| <a name="input_gcpProjectId"></a> [gcpProjectId](#input\_gcpProjectId) | gcp project id | `string` | n/a | yes |
| <a name="input_gcpRegion"></a> [gcpRegion](#input\_gcpRegion) | region where gke is deployed | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | An optional list of labels to apply to GCP resources. | `map(string)` | `{}` | no |
| <a name="input_num_servers"></a> [num\_servers](#input\_num\_servers) | The number of webserver instances to launch in each business unit spoke. Default<br>is 2. | `number` | `2` | no |
| <a name="input_num_volterra_nodes"></a> [num\_volterra\_nodes](#input\_num\_volterra\_nodes) | The number of Volterra gateway instances to launch in each business unit spoke.<br>Default is 1. | `number` | `1` | no |
| <a name="input_outside_cidr"></a> [outside\_cidr](#input\_outside\_cidr) | The CIDR to assign to shared outside VPC. Default is '100.64.96.0/20'. | `string` | `"100.64.96.0/20"` | no |
| <a name="input_projectPrefix"></a> [projectPrefix](#input\_projectPrefix) | prefix for resources | `string` | `"demo"` | no |
| <a name="input_resourceOwner"></a> [resourceOwner](#input\_resourceOwner) | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | The Volterra namespace into which Volterra resources will be managed. | `string` | n/a | yes |
| <a name="input_volterra_ssh_key"></a> [volterra\_ssh\_key](#input\_volterra\_ssh\_key) | An optional SSH key to add to Volterra nodes. | `string` | `""` | no |
| <a name="input_volterra_tenant"></a> [volterra\_tenant](#input\_volterra\_tenant) | The Volterra tenant to use. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_helpers"></a> [connection\_helpers](#output\_connection\_helpers) | A set of `gcloud` commands to connect to SSH, setup a forward-proxy, and to access<br>Code Server on each workstation, mapped by business unit. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
