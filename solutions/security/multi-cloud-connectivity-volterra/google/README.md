# GCP multi-cloud Volterra module

<!-- spell-checker: ignore volterra markdownlint tfvars -->
This module will create a set of Volterra GCP VPC Sites with ingress/egress gateways
configured and a virtual site that spans the CE sites.

![multi-cloud-volterra-hla.png](../images/multi-cloud-volterra-hla.png)
<!-- markdownlint-disable no-inline-html -->
<p align="center">Figure 1: High-level overview of solution; this module delivers the GCP resources</p>
<!-- markdownlint-enable no-inline-html -->

HTTP load balancers are created for each business unit service, and are advertised
on every CE site that match the selector predicate for the Virtual Site. This means
that existing resources can use DNS discovery via the Volterra gateways without
changing the deployment.

> See [Scenario](SCENARIO.md) document for details on why this solution was chosen
> for a hypothetical customer looking for a minimally invasive solution
> to multi-cloud networking.

## FAQs?

1. Why is there a single `outside` network? Can this work with multiple `outside` networks?

   For the purposes of this [multi-cloud-connectivity-volterra](../) demo, the
   module is creating a single VPC for `outside` use to minimise the risk of
   hitting VPC quota limits on GCP. The solution can function without issue if
   independent `outside` networks are used; the `outside` network is a requirement
   to use a 2-NIC Volterra Ingress/Egress gateway that can support routing traffic
   _from_ an `inside` network.

   See [Next Steps](SCENARIO.md#next-steps)

2. Can I deploy just this GCP sub-module?

   This module is expected to be launched as part of the
   [multi-cloud-connectivity-volterra](../) demo and is not guaranteed to
   function correctly as a standalone module. You can still launch it

   1. Populate a `terraform.tfvars` file with required values

      <!-- spell-checker: disable -->
      ```ini
      gcpProjectId       = "my-gcp-project-id"
      gcpRegion          = "us-central1"
      projectPrefix      = "my-prefix"
      buildSuffix        = "my-suffix"
      domain_name        = "shared.acme.com"
      volterra_namespace = "my-volterra-ns"
      volterra_tenant    = "my-tenant-id"
      ```
      <!-- spell-checker: enable -->

   2. Deploy with Terraform

      <!-- spell-checker: disable -->
      ```shell
      terraform init
      terraform apply -auto-approve
      ```
      <!-- spell-checker: enable -->

   3. Launch HTTP/HTTPS proxy tunnel via Workstation VM

      > See [Workstation](../../../../modules/google/terraform/workstation/README#using-workstation) docs for more options

      <!-- spell-checker: disable -->
      ```shell
      eval $(terraform output connection_helpers | jq -r 'fromjson | .bu21.proxy_tunnel')
      ```

      ```text
      Testing if tunnel connection works.
      Listening on port [8888].
      ```
      <!-- spell-checker: enable -->

   4. Configure browser to use `127.0.0.1:8888` as HTTP and HTTPS proxy

      ![proxy_8888.png](images/proxy_8888.png)
      <!-- markdownlint-disable no-inline-html -->
      <p align="center">Figure 2: Configure HTTP/HTTPS proxy in FireFox</p>
      <!-- markdownlint-enable no-inline-html -->

   5. Browse to advertised services; e.g. bu23app.shared.acme.com

      ![bu23app.png](images/bu23app.png)
      <!-- markdownlint-disable no-inline-html -->
      <p align="center">Figure 3: Viewing bu23app from Workstation on bu21 VPC</p>
      <!-- markdownlint-enable no-inline-html -->

   6. Cleanup

      `Ctrl-C` to terminate the HTTP/HTTPS proxy tunnel

      <!-- spell-checker: disable -->
      ```text
      Testing if tunnel connection works.
      Listening on port [8888].
      ^CServer shutdown complete.
      ```

      ```shell
      terraform destroy -auto-approve
      ```
      <!-- spell-checker: enable -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.5 |
| google | >= 3.77 |
| volterra | 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.77 |
| random | n/a |
| volterra | 0.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| inside | terraform-google-modules/network/google | 3.3.0 |
| outside | terraform-google-modules/network/google | 3.3.0 |
| region_locations | git::https://github.com/memes/terraform-google-volterra//modules/region-locations?ref=0.3.1 |  |
| volterra_sa | git::https://github.com/memes/terraform-google-volterra//modules/service-account?ref=0.3.1 |  |
| webserver_sa | terraform-google-modules/service-accounts/google | 4.0.2 |
| webserver_tls | ../../../../modules/google/terraform/tls |  |
| webservers | ../../../../modules/google/terraform/backend |  |
| workstation | ../../../../modules/google/terraform/workstation |  |

## Resources

| Name |
|------|
| [google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) |
| [google_compute_region_instance_group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_region_instance_group) |
| [google_compute_zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) |
| [random_shuffle](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) |
| [volterra_gcp_vpc_site](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/gcp_vpc_site) |
| [volterra_healthcheck](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/healthcheck) |
| [volterra_http_loadbalancer](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/http_loadbalancer) |
| [volterra_origin_pool](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/origin_pool) |
| [volterra_tf_params_action](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/tf_params_action) |
| [volterra_virtual_site](https://registry.terraform.io/providers/volterraedge/volterra/0.8.1/docs/resources/virtual_site) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buildSuffix | random build suffix for resources | `string` | n/a | yes |
| domain\_name | The DNS domain name that will be used as common parent generated DNS name of<br>loadbalancers. | `string` | n/a | yes |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | n/a | yes |
| volterra\_namespace | The Volterra namespace into which Volterra resources will be managed. | `string` | n/a | yes |
| volterra\_tenant | The Volterra tenant to use. | `string` | n/a | yes |
| business\_units | The set of VPCs to create with overlapping CIDRs. | <pre>map(object({<br>    cidr        = string<br>    mtu         = number<br>    workstation = bool<br>  }))</pre> | <pre>{<br>  "bu21": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": true<br>  },<br>  "bu22": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": false<br>  },<br>  "bu23": {<br>    "cidr": "10.1.0.0/16",<br>    "mtu": 1460,<br>    "workstation": false<br>  }<br>}</pre> | no |
| labels | An optional list of labels to apply to GCP resources. | `map(string)` | `{}` | no |
| num\_servers | The number of webserver instances to launch in each business unit spoke. Default<br>is 2. | `number` | `2` | no |
| num\_volterra\_nodes | The number of Volterra gateway instances to launch in each business unit spoke.<br>Default is 1. | `number` | `1` | no |
| outside\_cidr | The CIDR to assign to shared outside VPC. Default is '100.64.96.0/20'. | `string` | `"100.64.96.0/20"` | no |
| ssh\_key | An optional SSH key to add to Volterra nodes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| connection\_helpers | A set of `gcloud` commands to connect to SSH, setup a forward-proxy, and to access<br>Code Server on each workstation, mapped by business unit. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
