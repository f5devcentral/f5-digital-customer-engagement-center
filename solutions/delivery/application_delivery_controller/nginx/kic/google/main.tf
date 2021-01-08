provider "google" {
  alias   = "gcp"
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

module "gcp" {
  count        = 0
  source       = "../../../../../../infrastucture/google/terraform/network/min"
  kubernetes   = true
  gcpZone      = "us-east1-b"
  gcpRegion    = "us-east1"
  gcpProjectId = "myprojectid"
  providers = {
    google = google.gcp
  }
}

// module nginx {
//   source = "./nginx"
//   vpc = module.infa.vpc_nginx.id
//   subnets = [module.infa.subnet1.id, modules.ifra.subnet2.id]
//   admin_cidr

// }

// module controller {
//   vpc = module.infa.vpc_controller.id
//   subnets = [module.infa.subnet1.id, modules.]
// }
