############################ HTTP LB and Origin Pool - Acme ############################

resource "volterra_origin_pool" "acmeapp" {
  name                   = "${var.projectPrefix}-acmeapp-${random_id.buildSuffix.hex}"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    private_ip {
      ip = module.webserver["vpcAcmeApp1"].workspaceManagementAddress
      site_locator {
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_tgw_site.acmeAcme.name
        }
      }
      inside_network = true
    }

    labels = merge(local.volterraCommonLabels, {
      bu = "acme"
    })
  }
}

resource "volterra_http_loadbalancer" "acmeapp" {
  name                            = "${var.projectPrefix}-acmeapp-${random_id.buildSuffix.hex}"
  namespace                       = var.namespace
  no_challenge                    = true
  domains                         = ["acmeapp.shared.acme.com"]
  random                          = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true

  advertise_custom {
    advertise_where {
      port = 80
      site {
        ip      = "100.64.100.130"
        network = "SITE_NETWORK_INSIDE"
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_tgw_site.acmeBu1.name
        }
      }
    }
    advertise_where {
      port = 80
      site {
        ip      = "100.64.100.130"
        network = "SITE_NETWORK_INSIDE"
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_tgw_site.acmeBu2.name
        }
      }
    }
    advertise_where {
      port = 80
      site {
        ip      = "100.64.100.130"
        network = "SITE_NETWORK_INSIDE"
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_tgw_site.acmeAcme.name
        }
      }
    }
  }
  default_route_pools {
    pool {
      name = volterra_origin_pool.acmeapp.name
    }
  }

  http {
    dns_volterra_managed = false
  }
}
