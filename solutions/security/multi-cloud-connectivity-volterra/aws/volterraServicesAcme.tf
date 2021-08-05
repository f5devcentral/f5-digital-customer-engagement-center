

resource "volterra_origin_pool" "acmeapp" {
  name                   = "acmeapp"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  origin_servers {
    // One of the arguments from this list "voltadn_private_name srv6_private_name public_ip public_name custom_endpoint_object voltadn_private_ip srv6_private_ip private_ip private_name k8s_service consul_service" must be set

    private_ip {
      ip = module.webserver["vpcAcmeApp1"].workspaceManagementAddress
      site_locator {
        site {
          tenant    = var.volterraTenant
          namespace = "system"
          name      = volterra_aws_vpc_site.acmeAcme.name
        }
      }
      inside_network = true
    }

    labels = merge(local.volterra_common_labels, {
      "bu" = "Acme"
    })
  }

  port = 80

  // One of the arguments from this list "no_tls use_tls" must be set
  no_tls = true
}

resource "volterra_http_loadbalancer" "acmeapp" {
  name      = "acmeapp"
  namespace = var.namespace

  // One of the arguments from this list "do_not_advertise advertise_on_public_default_vip advertise_on_public advertise_custom" must be set

  advertise_custom {
    advertise_where {
      use_default_port = true
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
      name = volterra_origin_pool.acmeapp.name
    }
  }
  // One of the arguments from this list "no_challenge js_challenge captcha_challenge policy_based_challenge" must be set
  no_challenge = true

  domains = [format("acmeapp.%s", var.domain_name)]

  // One of the arguments from this list "least_active random source_ip_stickiness cookie_stickiness ring_hash round_robin" must be set
  random = true

  // One of the arguments from this list "http https_auto_cert https" must be set

  http {
    dns_volterra_managed = false
  }

  // One of the arguments from this list "disable_rate_limit rate_limit" must be set
  disable_rate_limit = true
  #  rate_limit {
  #    // One of the arguments from this list "custom_ip_allowed_list no_ip_allowed_list ip_allowed_list" must be set
  #
  #    ip_allowed_list {
  #      prefixes = ["0.0.0.0/0"]
  #    }
  #
  #    // One of the arguments from this list "no_policies policies" must be set
  #    no_policies = true
  #
  #    rate_limiter {
  #      total_number = "total_number"
  #      unit         = "unit"
  #    }
  #  }
  // One of the arguments from this list "service_policies_from_namespace no_service_policies active_service_policies" must be set
  service_policies_from_namespace = true
  // One of the arguments from this list "disable_waf waf waf_rule" must be set
  disable_waf = true
}
