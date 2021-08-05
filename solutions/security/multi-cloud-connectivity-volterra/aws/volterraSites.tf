#Volterra
resource "volterra_aws_vpc_site" "acmeBu1" {
  name        = "${var.projectPrefix}-bu1-aws-${var.buildSuffix}"
  namespace   = "system"
  aws_region  = var.awsRegion
  description = format("bu1 site (%s-%s)", var.projectPrefix, var.buildSuffix)
  labels = merge(local.volterra_common_labels, {
    bu = "bu1",
  })
  annotations = local.volterra_common_annotations

  ingress_egress_gw {
    aws_certified_hw         = "aws-byol-multi-nic-voltmesh"
    forward_proxy_allow_all  = true
    no_global_network        = true
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu1VoltSliAz1.id

      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcBu1.public_subnets[0]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu1VoltWorkloadAz1.id

      }
    }

    #    az_nodes {
    #      aws_az_name = local.awsAz2
    #
    #      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
    #      reserved_inside_subnet = false
    #      disk_size              = "disk_size"
    #
    #      inside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu1VoltSliAz2.id
    #      }
    #
    #      outside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = module.vpcTransitBu1.public_subnets[1]
    #      }
    #
    #      workload_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu1VoltWorkloadAz2.id
    #
    #      }
    #    }
    #
    #    az_nodes {
    #      aws_az_name = local.awsAz3
    #
    #      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
    #      reserved_inside_subnet = false
    #      disk_size              = "disk_size"
    #
    #      inside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu1VoltSliAz3.id
    #      }
    #
    #      outside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = module.vpcTransitBu1.public_subnets[2]
    #      }
    #
    #      workload_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu1VoltWorkloadAz3.id
    #
    #      }
    #    }

    // One of the arguments from this list "aws_cred assisted" must be set
  }
  aws_cred {
    name      = var.volterraCloudCred
    namespace = "system"
    tenant    = var.volterraTenant
  }
  # MEmes - this demo breaks if assisted mode is used;
  assisted      = false
  disk_size     = "80"
  instance_type = "t3.xlarge"
  // One of the arguments from this list "total_nodes no_worker_nodes nodes_per_az" must be set
  no_worker_nodes = true

  // One of the arguments from this list "new_vpc vpc_id" must be set
  vpc {
    vpc_id = module.vpcBu1.vpc_id
  }
  ssh_key = var.ssh_key

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyBu1" {
  depends_on       = [volterra_aws_vpc_site.acmeBu1]
  site_name        = volterra_aws_vpc_site.acmeBu1.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}


##########################################################################    BU2 site    #################################################################

resource "volterra_aws_vpc_site" "acmeBu2" {
  name        = "${var.projectPrefix}-bu2-aws-${var.buildSuffix}"
  namespace   = "system"
  aws_region  = var.awsRegion
  description = format("bu2 site (%s-%s)", var.projectPrefix, var.buildSuffix)
  labels = merge(local.volterra_common_labels, {
    bu = "bu2",
  })

  ingress_egress_gw {
    aws_certified_hw         = "aws-byol-multi-nic-voltmesh"
    forward_proxy_allow_all  = true
    no_global_network        = true
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu2VoltSliAz1.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcBu2.public_subnets[0]
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.bu2VoltWorkloadAz1.id

      }
    }

    #    az_nodes {
    #      aws_az_name = local.awsAz2
    #
    #      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
    #      reserved_inside_subnet = false
    #      disk_size              = "disk_size"
    #
    #      inside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu2VoltSliAz2.id
    #      }
    #
    #      outside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = module.vpcTransitBu2.public_subnets[1]
    #      }
    #
    #      workload_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu2VoltWorkloadAz2.id
    #
    #      }
    #    }
    #
    #    az_nodes {
    #      aws_az_name = local.awsAz3
    #
    #      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
    #      reserved_inside_subnet = false
    #      disk_size              = "disk_size"
    #
    #      inside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu2VoltSliAz3.id
    #      }
    #
    #      outside_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = module.vpcTransitBu2.public_subnets[2]
    #      }
    #
    #      workload_subnet {
    #        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
    #
    #        existing_subnet_id = aws_subnet.bu2VoltWorkloadAz3.id
    #
    #      }
    #    }
  }
  // One of the arguments from this list "aws_cred assisted" must be set

  aws_cred {
    name      = var.volterraCloudCred
    namespace = "system"
    tenant    = var.volterraTenant
  }
  # MEmes - this demo breaks if assisted mode is used;
  assisted      = false
  disk_size     = "80"
  instance_type = "t3.xlarge"
  // One of the arguments from this list "total_nodes no_worker_nodes nodes_per_az" must be set
  no_worker_nodes = true

  // One of the arguments from this list "new_vpc vpc_id" must be set

  vpc {
    vpc_id = module.vpcBu1.vpc_id
  }

  ssh_key = var.ssh_key

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyBu2" {
  depends_on       = [volterra_aws_vpc_site.acmeBu2]
  site_name        = volterra_aws_vpc_site.acmeBu2.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}

##########################################################################    Acme site    #################################################################

resource "volterra_aws_vpc_site" "acmeAcme" {
  name        = "${var.projectPrefix}-acme-aws-${var.buildSuffix}"
  namespace   = "system"
  aws_region  = var.awsRegion
  description = format("acme site (%s-%s)", var.projectPrefix, var.buildSuffix)
  labels = merge(local.volterra_common_labels, {
    bu = "acme",
  })

  ingress_egress_gw {
    aws_certified_hw         = "aws-byol-multi-nic-voltmesh"
    forward_proxy_allow_all  = true
    no_global_network        = true
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true

    az_nodes {
      aws_az_name = local.awsAz1

      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.acmeVoltSliAz1.id
      }

      outside_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = aws_subnet.acmeVoltWorkloadAz1.id
      }

      workload_subnet {
        // One of the arguments from this list "subnet_param existing_subnet_id" must be set

        existing_subnet_id = module.vpcAcme.public_subnets[0]

      }
    }
  }


  // One of the arguments from this list "aws_cred assisted" must be set

  aws_cred {
    name      = var.volterraCloudCred
    namespace = "system"
    tenant    = var.volterraTenant
  }
  # MEmes - this demo breaks if assisted mode is used;
  assisted      = false
  disk_size     = "80"
  instance_type = "t3.xlarge"
  // One of the arguments from this list "total_nodes no_worker_nodes nodes_per_az" must be set
  no_worker_nodes = true

  // One of the arguments from this list "new_vpc vpc_id" must be set

  vpc {
    vpc_id = module.vpcBu1.vpc_id
  }

  ssh_key = var.ssh_key

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true
}


resource "volterra_tf_params_action" "applyAcme" {
  depends_on       = [volterra_aws_vpc_site.acmeAcme]
  site_name        = volterra_aws_vpc_site.acmeAcme.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
}
