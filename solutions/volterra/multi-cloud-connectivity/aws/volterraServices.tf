############# WAF##############################
resource "volterra_waf" "waf" {
  name      = format("%s-waf-%s", var.projectPrefix, var.buildSuffix)
  namespace = "shared"
}

############################ Volterra Origin Pool (backend) ############################

resource "volterra_origin_pool" "app" {
  for_each               = local.business_units
  name                   = format("%s-%s-app-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    private_ip {
      ip = module.webserver[each.key].workspaceManagementAddress
      site_locator {
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_vpc_site.bu[each.key].name
        }
      }
      inside_network = true
    }

    labels = merge(local.volterraCommonLabels, {
      "bu" = each.key
    })
  }
}

############################ Volterra HTTP LB ############################

resource "volterra_http_loadbalancer" "app" {
  for_each                        = local.business_units
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
