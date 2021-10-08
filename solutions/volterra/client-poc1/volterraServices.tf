############################ Volterra Origin Pool (backend) ############################

resource "volterra_origin_pool" "app" {
  for_each               = var.awsBusinessUnits
  name                   = format("%s-%s-app-%s", var.projectPrefix, each.key, local.buildSuffix)
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  dynamic "origin_servers" {
    for_each = [for ws in setproduct([each.key], range(0, var.awsNumWebservers)) : module.webserver[join("", ws)].workspaceManagementAddress]
    content {
      private_ip {
        ip = origin_servers.value
        site_locator {
          site {
            tenant    = var.volterraTenant
            namespace = "system"
            name      = volterra_aws_vpc_site.main.name
          }
        }
        inside_network = true
      }
      labels = merge(local.volterraCommonLabels, {
        bu = each.key
      })
    }
  }
}

############################ Volterra HTTP LB ############################

resource "volterra_http_loadbalancer" "app" {
  name                            = format("%s-app-%s", var.projectPrefix, local.buildSuffix)
  namespace                       = var.namespace
  no_challenge                    = true
  domains                         = [format("app.%s", var.domain_name)]
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
          name      = volterra_virtual_site.site.name
          namespace = var.namespace
          tenant    = var.volterraTenant
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.app["bu1"].name
    }
    weight = 5
  }
  default_route_pools {
    pool {
      name = volterra_origin_pool.app["bu2"].name
    }
    weight = 5
  }

  http {
    dns_volterra_managed = false
  }
}
