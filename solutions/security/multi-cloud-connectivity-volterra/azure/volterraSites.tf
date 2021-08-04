locals {
  # TODO: @JeffGiroux - is this redundant?
  azure_common_labels = merge(var.labels, {
    owner = var.resourceOwner
    demo  = "multi-cloud-connectivity-volterra"
  })
  volterra_common_labels = merge(var.labels, {
    platform = "azure"
  })
  volterra_common_annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
}

############################ Volterra Azure VNet Sites ############################

resource "volterra_azure_vnet_site" "bu" {
  for_each       = local.vnets
  name           = format("%s-%s-azure-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace      = "system"
  labels         = local.volterra_common_labels
  annotations    = local.volterra_common_annotations
  azure_region   = azurerm_resource_group.rg[each.key].location
  resource_group = format("%s-%s-volterra-%s", var.projectPrefix, each.key, var.buildSuffix)
  machine_type   = "Standard_D3_v2"
  # MEmes - this demo breaks if assisted mode is used;
  assisted                = false
  logs_streaming_disabled = true
  no_worker_nodes         = true

  azure_cred {
    name      = var.volterraCloudCred
    namespace = "system"
    tenant    = var.volterraTenant
  }

  ingress_egress_gw {
    azure_certified_hw       = "azure-byol-multi-nic-voltmesh"
    no_forward_proxy         = true
    no_global_network        = true
    no_network_policy        = true
    no_outside_static_routes = true

    az_nodes {
      azure_az  = "1"
      disk_size = 80

      inside_subnet {
        subnet {
          subnet_name         = "internal"
          vnet_resource_group = true
        }
      }
      outside_subnet {
        subnet {
          subnet_name         = "external"
          vnet_resource_group = true
        }
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
                addr = "10.1.52.1"
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

  vnet {
    existing_vnet {
      resource_group = azurerm_resource_group.rg[each.key].name
      vnet_name      = module.network[each.key].vnet_name
    }
  }
}

resource "volterra_tf_params_action" "applyBu" {
  for_each         = local.vnets
  site_name        = volterra_azure_vnet_site.bu[each.key].name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_azure_vnet_site.bu]
}

############################ NIC Info ############################

# Collect data for Volterra node "site local inside" NIC
data "azurerm_network_interface" "sli" {
  for_each            = local.vnets
  name                = "master-0-sli"
  resource_group_name = format("%s-%s-volterra-%s", var.projectPrefix, each.key, var.buildSuffix)
  depends_on          = [volterra_tf_params_action.applyBu]
}
