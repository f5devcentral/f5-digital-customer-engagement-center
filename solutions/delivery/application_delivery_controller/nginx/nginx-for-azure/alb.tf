############################ Azure LB ############################

# Create App West Azure LB
resource "azurerm_lb" "appWest" {
  name                = format("%s-lb-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.appWest.location
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.appWest.name

  frontend_ip_configuration {
    name = "listener"
  }
  tags = {
    Name = format("%s-lb-appWest-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create App East Azure LB
resource "azurerm_lb" "appEast" {
  name                = format("%s-lb-appEast-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.appEast.location
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.appEast.name

  frontend_ip_configuration {
    name = "listener"
  }
  tags = {
    Name = format("%s-lb-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Backend for App Servers ############################

# Create App West backend pool
resource "azurerm_lb_backend_address_pool" "appWest" {
  name            = "backend"
  loadbalancer_id = azurerm_lb.appWest.id
}

# Create App East backend pool
resource "azurerm_lb_backend_address_pool" "appEast" {
  name            = "backend"
  loadbalancer_id = azurerm_lb.appEast.id
}

############################ Health Probes ############################

# Create App West health probe
resource "azurerm_lb_probe" "appWest" {
  loadbalancer_id     = azurerm_lb.appWest.id
  name                = "tcpProbe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Create App East health probe
resource "azurerm_lb_probe" "appEast" {
  loadbalancer_id     = azurerm_lb.appEast.id
  name                = "tcpProbe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

############################ LB Rules ############################

# Create App West frontend LB rule
resource "azurerm_lb_rule" "appWest" {
  name                           = "rule1"
  loadbalancer_id                = azurerm_lb.appWest.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "listener"
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.appWest.id]
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.appWest.id
}

# Create App East frontend LB rule
resource "azurerm_lb_rule" "appEast" {
  name                           = "rule1"
  loadbalancer_id                = azurerm_lb.appEast.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "listener"
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.appEast.id]
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.appEast.id
}
