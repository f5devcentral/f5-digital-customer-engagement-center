resource "aws_security_group" "externalWebservers" {
  count       = var.publicDomain != "" ? 1 : 0
  name        = format("%s-sg-externalWebservers-%s", var.projectPrefix, var.buildSuffix)
  description = "externalWebservers security group"
  vpc_id      = module.vpc["bu1"].vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = format("%s-sg-externalWebservers-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Create external facing webserver instances
module "externalWebserverBu1" {
  count             = var.publicDomain != "" ? 1 : 0
  source            = "../../../../modules/aws/terraform/webServer/"
  projectPrefix     = var.projectPrefix
  resourceOwner     = var.resourceOwner
  vpc               = module.vpc["bu1"].vpc_id
  keyName           = aws_key_pair.deployer.id
  subnets           = [module.vpc["bu1"].private_subnets[0], module.vpc["bu1"].private_subnets[1]]
  securityGroup     = aws_security_group.externalWebservers[0].id
  associatePublicIp = var.externalWebserverBu1.associatePublicIp
  desiredCapacity   = var.externalWebserverBu1.desiredCapacity
  albSubnets        = [module.vpc["bu1"].public_subnets[0], module.vpc["bu1"].public_subnets[1]]
}

############################ Volterra HTTPS External LB ############################

resource "volterra_origin_pool" "externalPool" {
  count                  = var.publicDomain != "" ? 1 : 0
  name                   = format("%s-%s-external-pool-%s", var.projectPrefix, "bu1", var.buildSuffix)
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    // One of the arguments from this list "private_name consul_service custom_endpoint_object vn_private_name public_ip public_name private_ip k8s_service vn_private_ip" must be set

    public_name {
      // One of the arguments from this list "inside_network outside_network vk8s_networks" must be set
      dns_name = module.externalWebserverBu1[0].albDnsName
    }
  }
}

resource "volterra_http_loadbalancer" "external-app" {
  count                           = var.publicDomain != "" ? 1 : 0
  name                            = format("%s-%s-external-app-%s", var.projectPrefix, "bu1", var.buildSuffix)
  namespace                       = var.namespace
  no_challenge                    = true
  domains                         = [format("external-app.%s", var.publicDomain)]
  random                          = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  advertise_on_public_default_vip = true
  waf {
    tenant    = var.volterraTenant
    namespace = "shared"
    name      = volterra_app_firewall.waf.name
  }
  https_auto_cert {
    http_redirect = true
    add_hsts      = false
    no_mtls       = true
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.externalPool[0].name
    }
  }
}
##################################################output###########################################################################
###################################################################################################################################

output "publicBu1Name" {
  description = "public DNS name for the external Bu1App"
  value       = var.publicDomain != "" ? format("external-app.%s", var.publicDomain) : null
}
