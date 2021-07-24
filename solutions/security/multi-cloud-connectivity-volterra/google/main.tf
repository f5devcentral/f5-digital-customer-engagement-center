terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.4.0"
    }
  }
}

resource "random_id" "build_suffix" {
  byte_length = 2
}

locals {
  build_suffix = coalesce(var.buildSuffix, random_id.build_suffix.hex)
  gcp_common_labels = merge(var.labels, {
    owner = var.resourceOwner
    demo  = "multi-cloud-connectivity-volterra"
  })
  volterra_common_labels = merge(var.labels, {
    owner    = var.resourceOwner
    demo     = "multi-cloud-connectivity-volterra"
    prefix   = var.projectPrefix
    suffix   = local.build_suffix
    platform = "gcp"
  })
  volterra_common_annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
  # Service account names are predictable; use this to avoid dependencies
  webserver_sa = format("%s-webserver-%s@%s.iam.gserviceaccount.com", var.projectPrefix, local.build_suffix, var.gcpProjectId)
  zones        = random_shuffle.zones.result
}

data "google_compute_zones" "zones" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  status  = "UP"
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    gcpProjectId = var.gcpProjectId
  }
}

# Create a service account for Volterra to manage VPC sites and store the
# GCP credentials in a Cloud Credentials object.
module "volterra_sa" {
  source                   = "git::https://github.com/memes/terraform-google-volterra//modules/service-account?ref=0.2.1"
  gcp_project_id           = var.gcpProjectId
  gcp_role_name            = replace(format("%s_volterra_site_%s", var.projectPrefix, local.build_suffix), "/[^a-z0-9_.]/", "_")
  gcp_service_account_name = format("%s-volterra-site-%s", var.projectPrefix, local.build_suffix)
  cloud_credential_name    = format("%s-gcp-%s", var.projectPrefix, local.build_suffix)
  labels                   = local.volterra_common_labels
  annotations              = local.volterra_common_annotations
}

module "webserver_sa" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "4.0.0"
  project_id   = var.gcpProjectId
  prefix       = var.projectPrefix
  names        = [format("webserver-%s", local.build_suffix)]
  descriptions = [format("Webserver service account (%s-%s)", var.projectPrefix, local.build_suffix)]
  project_roles = [
    "${var.gcpProjectId}=>roles/logging.logWriter",
    "${var.gcpProjectId}=>roles/monitoring.metricWriter",
    "${var.gcpProjectId}=>roles/monitoring.viewer",
  ]
  generate_keys = false
}

# Create a VPC for each business unit, with a single regional subnet in each
module "spoke" {
  for_each                               = var.business_units
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-%s-spoke-%s", var.projectPrefix, each.key, local.build_suffix)
  description                            = format("%s spoke VPC (%s-%s)", each.key, var.projectPrefix, local.build_suffix)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = each.value.mtu
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-%s-subnet-%s", var.projectPrefix, each.key, local.build_suffix)
      subnet_ip             = each.value.cidr
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

# Create a hub VPC with a single regional subnet
module "hub" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-hub-%s", var.projectPrefix, local.build_suffix)
  description                            = format("Hub VPC (%s-%s)", var.projectPrefix, local.build_suffix)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-hub-%s", var.projectPrefix, local.build_suffix)
      subnet_ip             = var.hub_cidr
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

module "workstation" {
  source        = "../../../../modules/google/terraform/workstation"
  projectPrefix = var.projectPrefix
  buildSuffix   = local.build_suffix
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  resourceOwner = var.resourceOwner
  subnet        = module.spoke[keys(var.business_units)[0]].subnets_self_links[0]
  zone          = local.zones[0]
  labels        = local.gcp_common_labels
  # Not using a NAT on the BU spokes, and Volterra gateway takes too long to
  # bootstrap; make sure the workstation gets a public address so it can pull
  # required packages and secrets.
  public_address = true
  # depends_on = [
  #  volterra_gcp_vpc_site.spoke,
  #  volterra_tf_params_action.spoke,
  # ]
}

module "webserver_tls" {
  source                  = "../../../../modules/google/terraform/tls"
  gcpProjectId            = var.gcpProjectId
  secret_manager_key_name = format("%s-webserver-tls-%s", var.projectPrefix, local.build_suffix)
  domain_name             = var.domain_name
  secret_accessors = [
    format("serviceAccount:%s", local.webserver_sa)
  ]
}

module "webservers" {
  for_each = { for ws in setproduct(keys(var.business_units), range(0, var.num_servers)) : join("", ws) => {
    name   = format("%s-%s-web-%s-%d", var.projectPrefix, ws[0], local.build_suffix, tonumber(ws[1]) + 1)
    subnet = module.spoke[ws[0]].subnets_self_links[0]
    zone   = element(local.zones, index(keys(var.business_units), ws[0]) * var.num_servers + tonumber(ws[1]))
  } }
  source          = "../../../../modules/google/terraform/backend"
  name            = each.value.name
  projectPrefix   = var.projectPrefix
  buildSuffix     = local.build_suffix
  gcpProjectId    = var.gcpProjectId
  resourceOwner   = var.resourceOwner
  service_account = local.webserver_sa
  subnet          = each.value.subnet
  zone            = each.value.zone
  labels          = local.gcp_common_labels
  tls_secret_key  = module.webserver_tls.tls_secret_key
  # Not using a NAT on the BU spokes, and Volterra gateway takes too long to
  # bootstrap; make sure the webservers get public addresses so they can pull
  # required packages and secrets.
  public_address = true
  # depends_on = [
  #  volterra_gcp_vpc_site.spoke,
  #  volterra_tf_params_action.spoke,
  # ]
}

# Allow ingress to webservers from any VM in the spoke CIDR
resource "google_compute_firewall" "spoke" {
  for_each  = var.business_units
  project   = var.gcpProjectId
  name      = format("%s-allow-all-%s-%s", var.projectPrefix, each.key, local.build_suffix)
  network   = module.spoke[each.key].network_self_link
  direction = "INGRESS"
  source_ranges = [
    each.value.cidr,
  ]
  target_service_accounts = [
    local.webserver_sa,
  ]
  allow {
    protocol = "ICMP"
  }
  allow {
    protocol = "TCP"
  }
  allow {
    protocol = "UDP"
  }
}

module "compute_locations" {
  source = "git::https://github.com/memes/terraform-google-volterra//modules/region-locations?ref=0.3.0"
}

resource "volterra_gcp_vpc_site" "spoke" {
  for_each    = var.business_units
  name        = format("%s-%s-%s", var.projectPrefix, each.key, local.build_suffix)
  namespace   = "system"
  description = format("%s site (%s-%s)", each.key, var.projectPrefix, local.build_suffix)
  labels = merge(local.volterra_common_labels, {
    bu = each.key
  })
  annotations = local.volterra_common_annotations
  coordinates {
    latitude  = module.compute_locations.lookup[var.gcpRegion].latitude
    longitude = module.compute_locations.lookup[var.gcpRegion].longitude
  }
  cloud_credentials {
    name      = module.volterra_sa.cloud_credential_name
    namespace = module.volterra_sa.cloud_credential_namespace
  }
  gcp_region              = var.gcpRegion
  instance_type           = "n1-standard-4"
  logs_streaming_disabled = true
  ssh_key                 = var.volterra_ssh_key
  ingress_egress_gw {
    gcp_certified_hw = "gcp-byol-multi-nic-voltmesh"
    node_number      = var.num_volterra_nodes
    gcp_zone_names   = local.zones
    #no_forward_proxy = true
    forward_proxy_allow_all  = true
    no_global_network        = true
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true
    inside_network {
      existing_network {
        name = module.spoke[each.key].network_name
      }
    }
    inside_subnet {
      existing_subnet {
        subnet_name = module.spoke[each.key].subnets_names[0]
      }
    }
    outside_network {
      existing_network {
        name = module.hub.network_name
      }
    }
    outside_subnet {
      existing_subnet {
        subnet_name = module.hub.subnets_names[0]
      }
    }
  }
  # These shouldn't be necessary, but lifecycle is flaky without them
  depends_on = [module.volterra_sa, module.spoke, module.hub]
}

resource "volterra_tf_params_action" "spoke" {
  for_each        = volterra_gcp_vpc_site.spoke
  site_name       = each.value.name
  site_kind       = "gcp_vpc_site"
  action          = "apply"
  wait_for_action = true
  # These shouldn't be necessary, but lifecycle is flaky without them
  depends_on = [module.volterra_sa, module.spoke, module.hub, volterra_gcp_vpc_site.spoke]
}

resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, local.build_suffix)
  namespace   = var.volterra_namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, local.build_suffix)
  labels      = local.volterra_common_labels
  annotations = local.volterra_common_annotations
  site_type   = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.volterra_common_labels : format("%s = %s", k, v)])
    ]
  }
}

resource "volterra_healthcheck" "spoke" {
  for_each    = var.business_units
  name        = format("%s-%s-%s", var.projectPrefix, each.key, local.build_suffix)
  namespace   = var.volterra_namespace
  description = format("HTTP healthcheck for service in %s (%s-%s)", each.key, var.projectPrefix, local.build_suffix)
  labels = merge(var.labels, {
    bu     = each.key
    demo   = "multi-cloud-connectivity-volterra"
    prefix = var.projectPrefix
    suffix = local.build_suffix
  })
  healthy_threshold   = 1
  interval            = 15
  timeout             = 2
  unhealthy_threshold = 2
  http_health_check {
    use_origin_server_name = true
    path                   = "/"
  }
}

resource "volterra_origin_pool" "spoke" {
  for_each               = var.business_units
  name                   = format("%s-%sapp-%s", var.projectPrefix, each.key, local.build_suffix)
  namespace              = var.volterra_namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  labels = merge(local.volterra_common_labels, {
    bu = each.key
  })
  annotations = local.volterra_common_annotations
  port        = 80
  no_tls      = true
  dynamic "origin_servers" {
    for_each = [for ws in setproduct([each.key], range(0, var.num_servers)) : module.webservers[join("", ws)].addresses.private]
    content {
      private_ip {
        ip = origin_servers.value
        site_locator {
          site {
            tenant    = var.volterra_tenant
            namespace = volterra_gcp_vpc_site.spoke[each.key].namespace
            name      = volterra_gcp_vpc_site.spoke[each.key].name
          }
        }
        inside_network = true
      }
      labels = merge(local.volterra_common_labels, {
        bu = each.key
      })
    }
  }
}

resource "volterra_http_loadbalancer" "spoke" {
  for_each    = var.business_units
  name        = format("%s-%sapp-%s", var.projectPrefix, each.key, local.build_suffix)
  namespace   = var.volterra_namespace
  description = format("HTTP service LB for %s (%s-%s)", each.key, var.projectPrefix, local.build_suffix)
  labels = merge(local.volterra_common_labels, {
    bu = each.key
  })
  annotations                     = local.volterra_common_annotations
  no_challenge                    = true
  random                          = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true
  domains                         = [format("%sapp.%s", each.key, var.domain_name)]
  http {
    dns_volterra_managed = false
  }
  advertise_custom {
    advertise_where {
      use_default_port = true
      virtual_site {
        network = "SITE_NETWORK_INSIDE"
        virtual_site {
          name      = volterra_virtual_site.site.name
          namespace = volterra_virtual_site.site.namespace
          tenant    = var.volterra_tenant
        }
      }
    }
  }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.spoke[each.key].name
      namespace = volterra_origin_pool.spoke[each.key].namespace
      tenant    = var.volterra_tenant
    }
  }
}
