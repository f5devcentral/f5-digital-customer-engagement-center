############################ Volterra AWS Transit Gateway Sites ############################

resource "volterra_aws_tgw_site" "main" {
  name                    = format("%s-aws-%s", var.projectPrefix, local.buildSuffix)
  namespace               = "system"
  logs_streaming_disabled = true

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcShared.vpc_id
    }
  }

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion
    vpc_id           = module.vpcShared.vpc_id
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
}

resource "volterra_tf_params_action" "main" {
  site_name        = volterra_aws_tgw_site.main.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_tgw_site.main]
}
