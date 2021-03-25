provider "volterra" {
  api_p12_file     = "/home/codespace/.volterra/f5-gsa.console.ves.volterra.io.api-creds.p12"
  url              = "https://f5-gsa.console.ves.volterra.io/api"
}

##Volterra
#resource "volterra_aws_tgw_site" "acmeBu1" {
#  name      = "acmebu1"
#  namespace = "system"
#
#  aws_parameters {
#    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
#    aws_region       = var.awsRegion
#
#    az_nodes {
#      aws_az_name = local.awsAz1
#
#      // One of the arguments from this list "reserved_inside_subnet inside_subnet" must be set
#      reserved_inside_subnet = true
#      disk_size              = "disk_size"
#
#      outside_subnet {
#        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
#
#        subnet_param {
#          ipv4 = "100.64.0.0/24"
#        }
#      }
#
#      workload_subnet {
#        // One of the arguments from this list "subnet_param existing_subnet_id" must be set
#
#        subnet_param {
#          ipv4 = "100.64.2.0/24"
#        }
#      }
#    }
#
#    // One of the arguments from this list "aws_cred assisted" must be set
#
#    aws_cred {
#      name      = "yossir"
#      namespace = "system"
#      tenant    = "f5-gsa-dhqmwfao"
#    }
#    disk_size     = "80"
#    instance_type = "t3.xlarge"
##    nodes_per_az  = "1"
#
#    // One of the arguments from this list "new_vpc vpc_id" must be set
#
#    new_vpc {
#      // One of the arguments from this list "name_tag autogenerate" must be set
#      name_tag = "acmeBu1Transit"
#
#      primary_ipv4 = "100.64.0.0/21"
#    }
#    ssh_key = var.sshPublicKey
#
#    // One of the arguments from this list "new_tgw existing_tgw" must be set
#
#    new_tgw {
#      // One of the arguments from this list "system_generated user_assigned" must be set
#      system_generated = true
#    }
#  }
#
#  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
#  logs_streaming_disabled = true
#}
