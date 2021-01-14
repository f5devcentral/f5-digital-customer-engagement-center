provider "aws" {

}


module "solution_controller" {

  source = "git::https://github.com/f5devcentral/f5-digital-customer-engagement-center//solutions/telemtry/nginx/controller/?ref=main"

  license               = ""
  key                   = ""
  certificate_authority = ""
  ssh                   = ""

}

output "controller" {
  value = module.solution.controller
}
