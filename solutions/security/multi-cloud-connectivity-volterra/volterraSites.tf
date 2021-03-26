provider "volterra" {
  api_p12_file = "/home/codespace/.volterra/f5-gsa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-gsa.console.ves.volterra.io/api"
}

#resource "volterra_http_loadbalancer" "example" {
#  name      = "acmecorp-web"
#  namespace = "staging"
#
#  // One of the arguments from this list "do_not_advertise advertise_on_public_default_vip advertise_on_public advertise_custom" must be set
#  advertise_on_public_default_vip = true
#
#  // One of the arguments from this list "no_challenge js_challenge captcha_challenge policy_based_challenge" must be set
#  no_challenge = true
#
#  domains = ["www.foo.com"]
#
#  // One of the arguments from this list "least_active random source_ip_stickiness cookie_stickiness ring_hash round_robin" must be set
#  random = true
#
#  // One of the arguments from this list "http https_auto_cert https" must be set
#
#  http {
#    dns_volterra_managed = true
#  }
#
#  // One of the arguments from this list "disable_rate_limit rate_limit" must be set
#
#  rate_limit {
#    // One of the arguments from this list "custom_ip_allowed_list no_ip_allowed_list ip_allowed_list" must be set
#
#    ip_allowed_list {
#      prefixes = ["192.168.20.0/24"]
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
#  // One of the arguments from this list "service_policies_from_namespace no_service_policies active_service_policies" must be set
#  service_policies_from_namespace = true
#  // One of the arguments from this list "disable_waf waf waf_rule" must be set
#  disable_waf = true
#}

#Volterra
resource "volterra_aws_tgw_site" "acmeBu1" {
  name      = "acme-bu1"
  namespace = "system"

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcBu1.vpc_id
    }
  }

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu1VoltSliAz1.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.public_subnets[0]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.intra_subnets[0]

      }
    }

    az_nodes {
      aws_az_name = local.awsAz2

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu1VoltSliAz2.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.public_subnets[1]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.intra_subnets[1]

      }
    }

    az_nodes {
      aws_az_name = local.awsAz3

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu1VoltSliAz3.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.public_subnets[2]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu1.intra_subnets[2]

      }
    }

    // One of the arguments from this list "aws_cred assisted" must be set

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }
    disk_size     = "80"
    instance_type = "t3.xlarge"
    #    nodes_per_az  = "1"

    // One of the arguments from this list "new_vpc vpc_id" must be set

    vpc_id = module.vpcTransitBu1.vpc_id

    ssh_key = var.sshPublicKey

    // One of the arguments from this list "new_tgw existing_tgw" must be set

    existing_tgw {
      // One of the arguments from this list "system_generated user_assigned" must be set
      tgw_id            = aws_ec2_transit_gateway.tgwBu1.id
      tgw_asn           = "64512"
      volterra_site_asn = "64532"
    }
  }

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyBu1" {
  depends_on       = [volterra_aws_tgw_site.acmeBu1]
  site_name        = volterra_aws_tgw_site.acmeBu1.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}


##########################################################################    BU2 site    #################################################################

resource "volterra_aws_tgw_site" "acmeBu2" {
  name      = "acme-bu2"
  namespace = "system"

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcBu2.vpc_id
    }
  }
  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu2VoltSliAz1.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.public_subnets[0]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.intra_subnets[0]

      }
    }

    az_nodes {
      aws_az_name = local.awsAz2

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu2VoltSliAz2.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.public_subnets[1]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.intra_subnets[1]

      }
    }

    az_nodes {
      aws_az_name = local.awsAz3

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu2VoltSliAz3.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.public_subnets[2]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitBu2.intra_subnets[2]

      }
    }

    // One of the arguments from this list "aws_cred assisted" must be set

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }
    disk_size     = "80"
    instance_type = "t3.xlarge"
    #    nodes_per_az  = "1"

    // One of the arguments from this list "new_vpc vpc_id" must be set

    vpc_id = module.vpcTransitBu2.vpc_id

    ssh_key = var.sshPublicKey

    // One of the arguments from this list "new_tgw existing_tgw" must be set

    existing_tgw {
      // One of the arguments from this list "system_generated user_assigned" must be set
      tgw_id            = aws_ec2_transit_gateway.tgwBu2.id
      tgw_asn           = "64512"
      volterra_site_asn = "64533"
    }
  }

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyBu2" {
  depends_on       = [volterra_aws_tgw_site.acmeBu2]
  site_name        = volterra_aws_tgw_site.acmeBu2.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}

##########################################################################    Acme site    #################################################################

resource "volterra_aws_tgw_site" "acmeAcme" {
  name      = "acme-acme"
  namespace = "system"

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcAcme.vpc_id
    }
  }

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = "disk_size"

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.acmeVoltSliAz1.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitAcme.public_subnets[0]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcTransitAcme.intra_subnets[0]

      }
    }


    // One of the arguments from this list "aws_cred assisted" must be set

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }
    disk_size     = "80"
    instance_type = "t3.xlarge"
    #    nodes_per_az  = "1"

    // One of the arguments from this list "new_vpc vpc_id" must be set

    vpc_id = module.vpcTransitAcme.vpc_id

    ssh_key = var.sshPublicKey

    // One of the arguments from this list "new_tgw existing_tgw" must be set

    existing_tgw {
      // One of the arguments from this list "system_generated user_assigned" must be set
      tgw_id            = aws_ec2_transit_gateway.tgwAcme.id
      tgw_asn           = "64512"
      volterra_site_asn = "64534"
    }
  }

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyAcme" {
  depends_on       = [volterra_aws_tgw_site.acmeAcme]
  site_name        = volterra_aws_tgw_site.acmeAcme.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}
