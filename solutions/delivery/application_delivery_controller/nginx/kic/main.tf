provider "aws" {
  region = var.aws_region
}
provider "google" {
  alias   = "gcp"
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}
provider "azurerm" {
  alias = "azure"
  // public, usgovernment, german, and china. Defaults to public
  environment = "public"
  features {}
}
module "aws" {
  source     = "../../../../../infrastucture/aws/terraform/"
  kubernetes = true
  aws_region = var.aws_region
  aws_az     = var.aws_az
  aws_az1    = var.aws_az1
}
resource "local_file" "kubeconfig-aws" {
  content  = module.aws.kubeconfig
  filename = "${path.module}/cluster-config"
}
// module "azure" {
//   count      = 0
//   source     = "../../../../../infrastucture/azure/terraform/"
//   kubernetes = true
//   providers = {
//     azurerm = azurerm.azure
//   }
// }
// module "gcp" {
//   count        = 0
//   source       = "../../../../../infrastucture/google/terraform/"
//   kubernetes   = true
//   gcpZone      = "us-east1-b"
//   gcpRegion    = "us-east1"
//   gcpProjectId = "myprojectid"
//   providers = {
//     google = google.gcp
//   }
// }

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
