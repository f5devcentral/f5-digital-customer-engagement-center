provider "aws" {
  region = "us-east-1" # CloudFront expects ACM resources in us-east-1 region only

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

data "terraform_remote_state" "webapp" {
  backend = "local"

  config = {
    path = "webapp/terraform.tfstate"
  }
}

locals {
  domain_name = var.domainName
  subdomain   = var.subDomain
}

##############################elastic search############################

#module "cognito" {
#  source     = "./cognito"
#  awsRegion = var.awsRegion
#  name = var.resourceOwner
#  domainName = var.subDomain
#}
#
#module "elasticsearch" {
#  source = "cloudposse/elasticsearch/aws"
#  # Cloud Posse recommends pinning every module to a specific version
#  # version     = "x.x.x"
#  namespace               = var.projectPrefix
#  stage                   = "dev"
#  name                    = var.domainName
#  dns_zone_id             = data.aws_route53_zone.this.zone_id
#  zone_awareness_enabled  = "true"
#  elasticsearch_version   = "7.9"
#  instance_type           = "t2.small.elasticsearch"
#  instance_count          = 4
#  ebs_volume_size         = 10
#  vpc_enabled             = false
#  #iam_role_arns           = ["arn:aws:iam::XXXXXXXXX:role/ops", "arn:aws:iam::XXXXXXXXX:role/dev"]
#  #iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
#  encrypt_at_rest_enabled = false
#  kibana_subdomain_name   = "kibana-es"
#  kibana_hostname_enabled = true
#  domain_hostname_enabled = true
#  create_iam_service_linked_role = false
#  cognito_authentication_enabled = true
#  cognito_iam_role_arn        = aws_iam_role.cognito_es_role.arn
#  cognito_identity_pool_id    = lookup(module.cognito.cognito_map, "identity_pool")
#  cognito_user_pool_id        = lookup(module.cognito.cognito_map, "user_pool")
#
#
#  advanced_options = {
#    "rest.action.multi.allow_explicit_index" = "true"
#  }
#  depends_on = [aws_iam_service_linked_role.es, aws_iam_role_policy_attachment.cognito_es_attach]
#}
resource "aws_wafv2_web_acl" "deviceIdAcl" {
  name        = "deviceIdAcl"
  description = "deviceIdAcl"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      count {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "deviceIdLogs"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "deviceIdLogs"
    sampled_requests_enabled   = true
  }
}
module "cloudfront" {
  depends_on = [aws_wafv2_web_acl.deviceIdAcl]
  source     = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${local.subdomain}.${local.domain_name}"]

  comment             = "My awesome CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = aws_wafv2_web_acl.deviceIdAcl.arn

  #logging_config = {
  #  bucket = module.log_bucket.this_s3_bucket_bucket_domain_name
  #  prefix = "cloudfront"
  #}
  origin = {
    juiceshop = {
      domain_name = data.terraform_remote_state.webapp.outputs.albDnsName
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1"]
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
    }

    deviceid = {
      domain_name = "us.gimp.zeronaught.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1"]
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
    }
    s3_one = {
      domain_name = module.s3_one.this_s3_bucket_bucket_regional_domain_name
      #      s3_origin_config = {
      #        origin_access_identity = "s3_bucket_one" # key in `origin_access_identities`
      #        # cloudfront_access_identity_path = "origin-access-identity/cloudfront/E5IGQAA1QO48Z" # external OAI resource
      #      }
    }
  }


  default_cache_behavior = {
    target_origin_id       = "juiceshop"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "DELETE", "PUT", "PATCH"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    #   lambda_function_association = {
    #
    #     # Valid keys: viewer-request, origin-request, viewer-response, origin-response
    #     viewer-request = {
    #       lambda_arn   = module.lambda_function.this_lambda_function_qualified_arn
    #       include_body = true
    #     }
    #
    #     origin-request = {
    #       lambda_arn = module.lambda_function.this_lambda_function_qualified_arn
    #     }
    #   }
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/__imp_apg__/*"
      target_origin_id       = "deviceid"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "DELETE", "PUT", "PATCH"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.this_acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }
}

######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
}

#############
# S3 buckets
#############

data "aws_canonical_user_id" "current" {}

module "s3_one" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "s3-one-${random_pet.this.id}"
  force_destroy = true
}

module "log_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "logs-${random_pet.this.id}"
  acl    = null
  grant = [{
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = data.aws_canonical_user_id.current.id
    }, {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
    # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }]
  force_destroy = true
}

#############################################
# Using packaged function from Lambda module
#############################################

#locals {
#  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
#  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
#}
#
#resource "null_resource" "download_package" {
#  triggers = {
#    downloaded = local.downloaded
#  }
#
#  provisioner "local-exec" {
#    command = "curl -L -o ${local.downloaded} ${local.package_url}"
#  }
#}
#
#data "null_data_source" "downloaded_package" {
#  inputs = {
#    id       = null_resource.download_package.id
#    filename = local.downloaded
#  }
#}
#
#module "lambda_function" {
#  source  = "terraform-aws-modules/lambda/aws"
#  version = "~> 1.0"
#
#  function_name = "${random_pet.this.id}-lambda"
#  description   = "My awesome lambda function"
#  handler       = "index.lambda_handler"
#  runtime       = "python3.8"
#
#  publish        = true
#  lambda_at_edge = true
#
#  create_package         = false
#  local_existing_package = data.null_data_source.downloaded_package.outputs["filename"]
#
#  # @todo: Missing CloudFront as allowed_triggers?
#
#  #    allowed_triggers = {
#  #      AllowExecutionFromAPIGateway = {
#  #        service = "apigateway"
#  #        arn     = module.api_gateway.this_apigatewayv2_api_execution_arn
#  #      }
#  #    }
#}
#
##########
# Route53
##########

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = module.cloudfront.this_cloudfront_distribution_domain_name
        zone_id = module.cloudfront.this_cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}

###########################
# Origin Access Identities
###########################
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_one.this_s3_bucket_arn}/static/*"]

    principals {
      type        = "AWS"
      identifiers = module.cloudfront.this_cloudfront_origin_access_identity_iam_arns
    }
  }
}

########
# Extra
########

resource "random_pet" "this" {
  length = 2
}