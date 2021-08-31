

resource "aws_security_group" "externalWebservers" {
  name        = format("%s-sg-externalWebservers-%s", var.projectPrefix, var.buildSuffix)
  description = "externalWebservers security group"
  vpc_id      = module.vpc["bu1"].vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  count             = var.externalWebserverBu1.deploy ? 1 : 0
  source            = "../../../../modules/aws/terraform/backend/"
  projectPrefix     = var.projectPrefix
  resourceOwner     = var.resourceOwner
  vpc               = module.vpc["bu1"].vpc_id
  keyName           = aws_key_pair.deployer.id
  subnets           = [module.vpc["bu1"].private_subnets[0], module.vpc["bu1"].private_subnets[1]]
  securityGroup     = aws_security_group.externalWebservers.id
  associatePublicIp = var.externalWebserverBu1.associatePublicIp
  desiredCapacity   = var.externalWebserverBu1.desiredCapacity
  startupCommand    = "docker run -d --restart always -p 80:3000 bkimminich/juice-shop"
  albSubnets        = [module.vpc["bu1"].public_subnets[0], module.vpc["bu1"].public_subnets[1]]
}

############################ Volterra HTTPS External LB ############################

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
    namespace = var.namespace
    name      = volterra_waf.waf.name
  }
  https_auto_cert {
    http_redirect = true
    add_hsts      = false
    no_mtls       = true
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.app["bu1"].name
    }
  }
}
##################################################output###########################################################################
###################################################################################################################################

output "albDnsNameBu1" {
  description = "albDnsName for the external web app in bu1"
  value       = var.externalWebserverBu1.deploy ? module.externalWebserverBu1[0].albDnsName : null
}
