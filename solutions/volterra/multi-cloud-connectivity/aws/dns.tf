############################ DNS Resolver Endpoint ############################

resource "aws_route53_resolver_endpoint" "bu" {
  for_each           = var.awsBusinessUnits
  name               = format("%s-%s-resolver-%s", var.projectPrefix, each.key, var.buildSuffix)
  direction          = "OUTBOUND"
  security_group_ids = [module.vpc[each.key].default_security_group_id]

  ip_address {
    subnet_id = module.vpc[each.key].public_subnets[0]
  }
  ip_address {
    subnet_id = module.vpc[each.key].public_subnets[1]
  }

  tags = {
    Name      = format("%s-%s-resolver-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ DNS Resolver Rule (aka delegation) ############################

resource "aws_route53_resolver_rule" "bu" {
  for_each             = var.awsBusinessUnits
  name                 = format("%s-%s-route53rule-%s", var.projectPrefix, each.key, var.buildSuffix)
  domain_name          = var.domain_name
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.bu[each.key].id

  target_ip {
    ip = data.aws_network_interface.volterra_sli[each.key].private_ip
  }

  tags = {
    Name      = format("%s-%s-route53rule-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ DNS Rule Association ############################

resource "aws_route53_resolver_rule_association" "bu" {
  for_each         = var.awsBusinessUnits
  resolver_rule_id = aws_route53_resolver_rule.bu[each.key].id
  vpc_id           = module.vpc[each.key].vpc_id
}
