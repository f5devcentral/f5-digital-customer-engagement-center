############################ Locals ############################

locals {
  volterraCommonLabels = {
    demo     = "aws-tgw"
    owner    = var.resourceOwner
    prefix   = var.projectPrefix
    suffix   = var.buildSuffix
    platform = "aws"
  }
}

############################ Volterra AWS TGW Site - BU1 ############################

resource "volterra_aws_tgw_site" "acmeBu1" {
  name                    = "${var.projectPrefix}-bu1-${random_id.buildSuffix.hex}"
  namespace               = "system"
  logs_streaming_disabled = true

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion
    instance_type    = "t3.xlarge"
    disk_size        = "80"
    ssh_key          = var.sshPublicKey
    assisted         = false
    no_worker_nodes  = true
    vpc_id           = module.vpcTransitBu1.vpc_id

    az_nodes {
      aws_az_name            = local.awsAz1
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        existing_subnet_id = aws_subnet.bu1VoltSliAz1.id
      }
      outside_subnet {
        existing_subnet_id = module.vpcTransitBu1.public_subnets[0]
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.bu1VoltWorkloadAz1.id
      }
    }

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }

    existing_tgw {
      tgw_id            = aws_ec2_transit_gateway.tgwBu1.id
      tgw_asn           = "64512"
      volterra_site_asn = "64532"
    }
  }

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcBu1.vpc_id
    }
  }

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "acmeLabelsBu1" {
  name             = volterra_aws_tgw_site.acmeBu1.name
  site_type        = "aws_tgw_site"
  labels           = local.volterraCommonLabels
  ignore_on_delete = true
}

resource "volterra_tf_params_action" "applyBu1" {
  site_name        = volterra_aws_tgw_site.acmeBu1.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_tgw_site.acmeBu1]
}

############################ Volterra AWS TGW Site - BU2 ############################

resource "volterra_aws_tgw_site" "acmeBu2" {
  name                    = "${var.projectPrefix}-bu2-${random_id.buildSuffix.hex}"
  namespace               = "system"
  logs_streaming_disabled = true

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion
    instance_type    = "t3.xlarge"
    disk_size        = "80"
    ssh_key          = var.sshPublicKey
    assisted         = false
    no_worker_nodes  = true
    vpc_id           = module.vpcTransitBu2.vpc_id

    az_nodes {
      aws_az_name            = local.awsAz1
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        existing_subnet_id = aws_subnet.bu2VoltSliAz1.id
      }
      outside_subnet {
        existing_subnet_id = module.vpcTransitBu2.public_subnets[0]
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.bu2VoltWorkloadAz1.id
      }
    }

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }

    existing_tgw {
      tgw_id            = aws_ec2_transit_gateway.tgwBu2.id
      tgw_asn           = "64512"
      volterra_site_asn = "64533"
    }
  }

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcBu2.vpc_id
    }
  }

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "acmeLabelsBu2" {
  name             = volterra_aws_tgw_site.acmeBu2.name
  site_type        = "aws_tgw_site"
  labels           = local.volterraCommonLabels
  ignore_on_delete = true
}

resource "volterra_tf_params_action" "applyBu2" {
  site_name        = volterra_aws_tgw_site.acmeBu2.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_tgw_site.acmeBu2]
}

############################ Volterra AWS TGW Site - Acme ############################

resource "volterra_aws_tgw_site" "acmeAcme" {
  name                    = "${var.projectPrefix}-acme-${random_id.buildSuffix.hex}"
  namespace               = "system"
  logs_streaming_disabled = true

  aws_parameters {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    aws_region       = var.awsRegion
    instance_type    = "t3.xlarge"
    disk_size        = "80"
    ssh_key          = var.sshPublicKey
    assisted         = false
    no_worker_nodes  = true
    vpc_id           = module.vpcTransitAcme.vpc_id

    az_nodes {
      aws_az_name            = local.awsAz1
      reserved_inside_subnet = false
      disk_size              = 100

      inside_subnet {
        existing_subnet_id = aws_subnet.acmeVoltSliAz1.id
      }
      outside_subnet {
        existing_subnet_id = module.vpcTransitAcme.public_subnets[0]
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.acmeVoltWorkloadAz1.id
      }
    }

    aws_cred {
      name      = var.volterraCloudCred
      namespace = "system"
      tenant    = var.volterraTenant
    }

    existing_tgw {
      tgw_id            = aws_ec2_transit_gateway.tgwAcme.id
      tgw_asn           = "64512"
      volterra_site_asn = "64534"
    }
  }

  vpc_attachments {
    vpc_list {
      vpc_id = module.vpcAcme.vpc_id
    }
  }

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "acmeLabelsAcme" {
  name             = volterra_aws_tgw_site.acmeAcme.name
  site_type        = "aws_tgw_site"
  labels           = local.volterraCommonLabels
  ignore_on_delete = true
}

resource "volterra_tf_params_action" "applyAcme" {
  site_name        = volterra_aws_tgw_site.acmeAcme.name
  site_kind        = "aws_tgw_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_tgw_site.acmeAcme]
}
