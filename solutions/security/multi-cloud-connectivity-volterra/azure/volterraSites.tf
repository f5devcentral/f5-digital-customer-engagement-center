provider "volterra" {
}

############################ Azure Subnet Names ############################

data "azurerm_subnet" "transitBu11_outside" {
  name                 = "external"
  virtual_network_name = module.network["transitBu11"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu11"].name

  depends_on = [module.network["transitBu11"].vnet_subnets]
}

data "azurerm_subnet" "transitBu11_inside" {
  name                 = "internal"
  virtual_network_name = module.network["transitBu11"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu11"].name

  depends_on = [module.network["transitBu11"].vnet_subnets]
}

data "azurerm_subnet" "transitBu12_outside" {
  name                 = "external"
  virtual_network_name = module.network["transitBu12"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu12"].name

  depends_on = [module.network["transitBu12"].vnet_subnets]
}

data "azurerm_subnet" "transitBu12_inside" {
  name                 = "internal"
  virtual_network_name = module.network["transitBu12"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu12"].name

  depends_on = [module.network["transitBu12"].vnet_subnets]
}

data "azurerm_subnet" "transitBu13_outside" {
  name                 = "external"
  virtual_network_name = module.network["transitBu13"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu13"].name

  depends_on = [module.network["transitBu13"].vnet_subnets]
}

data "azurerm_subnet" "transitBu13_inside" {
  name                 = "internal"
  virtual_network_name = module.network["transitBu13"].vnet_name
  resource_group_name  = azurerm_resource_group.rg["transitBu13"].name

  depends_on = [module.network["transitBu13"].vnet_subnets]
}


############################ Volterra Azure VNet Site - BU11 ############################

resource "volterra_azure_vnet_site" "bu11" {
  name                    = format("%s-bu11-azure-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  namespace               = "system"
  azure_region            = azurerm_resource_group.rg["transitBu11"].location
  resource_group          = format("%s-bu11-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  machine_type            = "Standard_D3_v2"
  assisted                = var.assisted
  logs_streaming_disabled = true

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
          subnet_name         = data.azurerm_subnet.transitBu11_inside.name
          vnet_resource_group = true
        }
      }
      outside_subnet {
        subnet {
          subnet_name         = data.azurerm_subnet.transitBu11_outside.name
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
                addr = "100.64.49.1"
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
      resource_group = azurerm_resource_group.rg["transitBu11"].name
      vnet_name      = module.network["transitBu11"].vnet_name
    }
  }
}

resource "volterra_tf_params_action" "applyBu11" {
  count            = var.assisted ? 0 : 1
  site_name        = volterra_azure_vnet_site.bu11.name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_azure_vnet_site.bu11]
}


############################ Volterra Azure VNet Site - BU12 ############################

resource "volterra_azure_vnet_site" "bu12" {
  name                    = format("%s-bu12-azure-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  namespace               = "system"
  azure_region            = azurerm_resource_group.rg["transitBu12"].location
  resource_group          = format("%s-bu12-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  machine_type            = "Standard_D3_v2"
  assisted                = var.assisted
  logs_streaming_disabled = true

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
          subnet_name         = data.azurerm_subnet.transitBu12_inside.name
          vnet_resource_group = true
        }
      }
      outside_subnet {
        subnet {
          subnet_name         = data.azurerm_subnet.transitBu12_outside.name
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
                addr = "100.64.65.1"
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
      resource_group = azurerm_resource_group.rg["transitBu12"].name
      vnet_name      = module.network["transitBu12"].vnet_name
    }
  }
}

resource "volterra_tf_params_action" "applyBu12" {
  count            = var.assisted ? 0 : 1
  site_name        = volterra_azure_vnet_site.bu12.name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_azure_vnet_site.bu12]
}

############################ Volterra Azure VNet Site - BU13 ############################

resource "volterra_azure_vnet_site" "bu13" {
  name                    = format("%s-bu13-azure-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  namespace               = "system"
  azure_region            = azurerm_resource_group.rg["transitBu13"].location
  resource_group          = format("%s-bu13-volterra-%s", var.volterraUniquePrefix, random_id.buildSuffix.hex)
  machine_type            = "Standard_D3_v2"
  assisted                = var.assisted
  logs_streaming_disabled = true

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
          subnet_name         = data.azurerm_subnet.transitBu13_inside.name
          vnet_resource_group = true
        }
      }
      outside_subnet {
        subnet {
          subnet_name         = data.azurerm_subnet.transitBu13_outside.name
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
                addr = "100.64.81.1"
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
      resource_group = azurerm_resource_group.rg["transitBu13"].name
      vnet_name      = module.network["transitBu13"].vnet_name
    }
  }
}

resource "volterra_tf_params_action" "applyBu13" {
  count            = var.assisted ? 0 : 1
  site_name        = volterra_azure_vnet_site.bu13.name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_azure_vnet_site.bu13]
}
