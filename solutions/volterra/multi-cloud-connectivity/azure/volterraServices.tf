############################ Volterra Origin Pool (backend) ############################

resource "volterra_origin_pool" "app" {
  for_each               = var.business_units
  name                   = format("%s-%s-app-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  dynamic "origin_servers" {
    for_each = [for ws in setproduct([each.key], range(0, var.num_servers)) : module.backend[join("", ws)].privateIp]
    content {
      private_ip {
        ip = origin_servers.value
        site_locator {
          site {
            tenant    = var.volterraTenant
            namespace = "system"
            name      = volterra_azure_vnet_site.bu[each.key].name
          }
        }
        inside_network = true
      }

      labels = merge(local.volterra_common_labels, {
        "bu" = each.key
      })
    }
  }
}

############################ Volterra HTTP LB ############################

resource "volterra_http_loadbalancer" "app" {
  for_each                        = var.business_units
  name                            = format("%s-%s-app-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace                       = var.namespace
  no_challenge                    = true
  domains                         = [format("%sapp.%s", each.key, var.domain_name)]
  random                          = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true

  advertise_custom {
    advertise_where {
      port = 80
      virtual_site {
        network = "SITE_NETWORK_INSIDE"
        virtual_site {
          name      = var.volterraVirtualSite
          namespace = var.namespace
          tenant    = var.volterraTenant
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.app[each.key].name
    }
  }

  http {
    dns_volterra_managed = false
  }
}
