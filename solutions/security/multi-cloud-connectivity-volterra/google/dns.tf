data "google_compute_region_instance_group" "inside" {
  for_each   = volterra_gcp_vpc_site.inside
  name       = each.value.name
  project    = var.gcpProjectId
  region     = var.gcpRegion
  depends_on = [volterra_tf_params_action.inside]
}
/*
# TODO: @memes - can inside addresses of Volterra gateways be found in API or
# through service discovery?
#
# This is still an abomination of an approach; it relies on observed Volterra
# gateway deployment patterns rather than DNS forwarding or an ILB to MIG.
data "google_compute_instance" "inside" {
  for_each  = toset(flatten([for ig in data.google_compute_region_instance_group.inside : [for vm in ig.instances : vm.instance]]))
  self_link = each.value

  depends_on = [volterra_tf_params_action.inside]
}

locals {
  network_dns_hosts = { for vm in data.google_compute_instance.inside : vm.network_interface[1].network => vm.network_interface[1].network_ip... }
}

module "dns" {
  for_each    = var.business_units
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "3.1.0"
  project_id  = var.gcpProjectId
  type        = "private"
  name        = format("%s-private-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  domain      = format("%s.", var.domain_name)
  description = format("Resolve all %s hosts to Volterra gateway (%s-%s)", each.key, var.projectPrefix, var.buildSuffix)
  labels = merge(local.gcp_common_labels, {
    bu = each.key
  })
  private_visibility_config_networks = [module.inside[each.key].network_self_link]
  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        format("inside.%s.", var.domain_name)
      ]
    },
    {
      name    = "inside"
      type    = "A"
      ttl     = 300
      records = local.network_dns_hosts[module.inside[each.key].network_self_link]
    }
  ]

  depends_on = [volterra_tf_params_action.inside]
}
*/
