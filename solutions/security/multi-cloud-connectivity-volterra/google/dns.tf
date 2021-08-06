# TODO: @memes - can inside addresses of Volterra gateways be found in API or
# through service discovery?
#
# This is still an abomination of an approach; it relies on observed Volterra
# gateway deployment patterns rather than DNS forwarding or an ILB to MIG.
locals {
  #bu_gateway_instances = {for k,v in var.business_units: k => [for vm in data.google_compute_region_instance_group.inside[k].instances: vm.instance]}
  #gateway_instances = toset(flatten([for k,v in var.business_units: [for vm in data.google_compute_region_instance_group.inside[k].instances: vm.instance]]))
  #bu_inside_ips = {for k,v in local.bu_gateway_instances: k => [for vm in v: data.google_compute_instance.inside[vm].network_interface[1].network_ip]}
  #bu_gateway_instances = {for k,v in volterra_tf_params_action.inside: k => flatten([for m in regex("(?s)instance_names\\s*=\\s*\\[\\s*([^\\]]*)", v.tf_output): regexall("(?m)^\\s*\"([^\"]+)\",?\\s*$", m)])}
  #gateway_instances = toset(flatten([for k,v in local.bu_gateway_instances: v]))
  #outside_private_ips = {for k,v in volterra_tf_params_action.inside: k => flatten([for m in regex("(?s)master_private_ip_address\\s*=\\s*{\\s*([^}]*)}", v.tf_output): regexall("(?m)^\\s*\"[^\"]+\"\\s*=\\s*\"([^\"]+)\"\\s*$", m)])}
  #bu_tags = { for k,v in volterra_tf_params_action.inside: k => try(regex("(?m)gcp_object_name\\s*=\\s*(.*)$", v.tf_output)[0], "") }
}

# To avoid nested for looping of data sources, use the grepped output of
# volterra_tf_params_action and a script to find VMs sharing a network tag and
# mung the addresses into a comma-separated string.
data "external" "inside_ips" {
  for_each = var.business_units
  program  = ["${path.module}/files/inside_ips_for_tag.sh"]
  query = {
    project = var.gcpProjectId
    tag     = try(regex("(?m)gcp_object_name\\s*=\\s*(.*)$", volterra_tf_params_action.inside[each.key].tf_output)[0], "")
  }

  depends_on = [
    volterra_tf_params_action.inside,
  ]
}

resource "google_dns_managed_zone" "inside" {
  for_each    = var.business_units
  project     = var.gcpProjectId
  name        = format("%s-private-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  dns_name    = format("%s.", var.domain_name)
  description = format("Resolve all %s hosts to Volterra gateway (%s-%s)", each.key, var.projectPrefix, var.buildSuffix)
  labels = merge(local.gcp_common_labels, {
    bu = each.key
  })
  visibility = "private"
  private_visibility_config {
    networks {
      network_url = module.inside[each.key].network_self_link
    }
  }
}

resource "google_dns_record_set" "inside_cname" {
  for_each     = var.business_units
  project      = var.gcpProjectId
  managed_zone = google_dns_managed_zone.inside[each.key].name
  name         = format("*.%s.", var.domain_name)
  type         = "CNAME"
  ttl          = 300
  rrdatas = [
    format("inside.%s.", var.domain_name),
  ]
}

resource "google_dns_record_set" "inside_a" {
  for_each     = var.business_units
  project      = var.gcpProjectId
  managed_zone = google_dns_managed_zone.inside[each.key].name
  name         = format("inside.%s.", var.domain_name)
  type         = "A"
  ttl          = 300
  rrdatas      = split(",", data.external.inside_ips[each.key].result.addresses)
  depends_on   = [volterra_tf_params_action.inside]
}
