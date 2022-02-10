############################ Volterra Virtual Site ############################

resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, local.buildSuffix)
  namespace   = var.namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, local.buildSuffix)
  labels      = local.volterraCommonLabels
  annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
  site_type = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.volterraCommonLabels : format("%s = %s", k, v)])
    ]
  }
}

############################ Volterra AWS VPC Sites ############################

resource "volterra_aws_vpc_site" "main" {
  name                    = format("%s-aws-%s", var.projectPrefix, local.buildSuffix)
  namespace               = "system"
  aws_region              = var.awsRegion
  annotations             = local.volterraCommonAnnotations
  instance_type           = "t3.xlarge"
  disk_size               = "80"
  ssh_key                 = var.ssh_key
  assisted                = false
  logs_streaming_disabled = true
  no_worker_nodes         = true

  aws_cred {
    name      = var.volterraCloudCredAWS
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
        existing_subnet_id = aws_subnet.sli.id
      }
      outside_subnet {
        existing_subnet_id = module.sharedVpc.public_subnets[0]
      }
    }
  }

  vpc {
    vpc_id = module.sharedVpc.vpc_id
  }

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_aws_vpc_site.main.name
  site_type        = "aws_vpc_site"
  labels           = local.volterraCommonLabels
  ignore_on_delete = true
}

resource "volterra_tf_params_action" "main" {
  site_name        = volterra_aws_vpc_site.main.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_vpc_site.main]
}

############################ Collect Volterra Info ############################

# Instance info
data "aws_instances" "volterra" {
  instance_state_names = ["running"]
  instance_tags = {
    "ves-io-site-name" = volterra_aws_vpc_site.main.name
  }

  depends_on = [volterra_tf_params_action.main]
}

# NIC info
data "aws_network_interface" "volterra_sli" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.volterra.ids[0]]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}

data "aws_network_interface" "volterra_outside" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.volterra.ids[0]]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
}
