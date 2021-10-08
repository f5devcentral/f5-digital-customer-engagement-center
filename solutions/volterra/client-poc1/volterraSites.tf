############################ Volterra Virtual Site ############################

resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, local.buildSuffix)
  namespace   = var.namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, local.buildSuffix)
  labels      = local.volterraCommonLabels
  annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
  site_type = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.volterraCommonLabels : format("%s = %s", k, v)])
    ]
  }
}

############################ Volterra AWS Transit Gateway Sites ############################

resource "volterra_aws_tgw_site" "main" {
  name                    = format("%s-aws-%s", var.projectPrefix, local.buildSuffix)
  namespace               = "system"
  labels                  = local.volterraCommonLabels
  annotations             = local.volterraCommonAnnotations
  logs_streaming_disabled = true

  dynamic "vpc_attachments" {
    for_each = values(module.vpc)[*]["vpc_id"]
    content {
      vpc_list {
        vpc_id = vpc_attachments.value
      }
    }
  }

  aws_parameters {
    aws_region       = var.awsRegion
    vpc_id           = module.vpcShared.vpc_id
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    disk_size        = "80"
    instance_type    = "t3.xlarge"
    ssh_key          = var.ssh_key
    assisted         = false
    no_worker_nodes  = true

    az_nodes {
      aws_az_name            = local.awsAz1
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        existing_subnet_id = aws_subnet.sli.id
      }
      outside_subnet {
        existing_subnet_id = module.vpcShared.public_subnets[0]
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.workload.id
      }
    }

    aws_cred {
      name      = var.volterraCloudCredAWS
      namespace = "system"
      tenant    = var.volterraTenant
    }

    existing_tgw {
      tgw_id            = aws_ec2_transit_gateway.main.id
      tgw_asn           = "64512"
      volterra_site_asn = "64532"
    }
  }

  vn_config {
    no_global_network        = true
    no_outside_static_routes = true

    inside_static_routes {
      static_route_list {
        custom_static_route {
          subnets {
            ipv4 {
              prefix = "10.0.0.0"
              plen   = "8"
            }
          }
          nexthop {
            type = "NEXT_HOP_USE_CONFIGURED"
            nexthop_address {
              ipv4 {
                addr = "100.64.6.1"
              }
            }
          }
          attrs = [
            "ROUTE_ATTR_INSTALL_FORWARDING",
            "ROUTE_ATTR_INSTALL_HOST"
          ]
        }
      }
    }
  }
}

resource "volterra_tf_params_action" "main" {
  site_name        = volterra_aws_tgw_site.main.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_tgw_site.main]
}

############################ Collect Volterra Info ############################

# Instance info
data "aws_instances" "volterra" {
  instance_state_names = ["running"]
  instance_tags = {
    "ves.io/site_name" = volterra_aws_tgw_site.main.name
  }

  depends_on = [volterra_tf_params_action.main]
}

# NIC info
data "aws_network_interface" "volterra_sli" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.volterra.ids[0]]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}
