############################ Volterra AWS VPC Sites ############################

resource "volterra_aws_vpc_site" "bu" {
  for_each      = local.business_units
  name          = format("%s-%s-aws-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace     = "system"
  aws_region    = var.awsRegion
  labels        = local.volterra_common_labels
  annotations   = local.volterra_common_annotations
  instance_type = "t3.xlarge"
  disk_size     = "80"
  ssh_key       = var.ssh_key
  # MEmes - this demo breaks if assisted mode is used;
  assisted                = false
  logs_streaming_disabled = true
  no_worker_nodes         = true

  aws_cred {
    name      = var.volterraCloudCred
    namespace = "system"
    tenant    = var.volterraTenant
  }

  ingress_egress_gw {
    aws_certified_hw         = "aws-byol-multi-nic-voltmesh"
    forward_proxy_allow_all  = true
    no_global_network        = true
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true

    az_nodes {
      aws_az_name            = local.awsAz1
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        existing_subnet_id = aws_subnet.sli[each.key].id
      }
      outside_subnet {
        existing_subnet_id = module.vpc[each.key].public_subnets[0]
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.workload[each.key].id
      }
    }

    inside_static_routes {
      static_route_list {
        custom_static_route {
          subnets {
            ipv4 {
              prefix = "10.1.0.0"
              plen   = "16"
            }
          }
          nexthop {
            type = "NEXT_HOP_USE_CONFIGURED"
            nexthop_address {
              ipv4 {
                addr = "10.1.20.1"
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

  vpc {
    vpc_id = module.vpc[each.key].vpc_id
  }
}

resource "volterra_tf_params_action" "applyBu" {
  for_each         = local.business_units
  site_name        = volterra_aws_vpc_site.bu[each.key].name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_vpc_site.bu]
}

############################ Collect Volterra Info ############################

# Instance info
data "aws_instances" "volterra" {
  for_each             = local.business_units
  instance_state_names = ["running"]
  instance_tags = {
    "ves.io/site_name" = volterra_aws_vpc_site.bu[each.key].name
  }

  depends_on = [volterra_tf_params_action.applyBu]
}

# NIC info
data "aws_network_interface" "volterra_sli" {
  for_each = local.business_units
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.volterra[each.key].ids[0]]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}
