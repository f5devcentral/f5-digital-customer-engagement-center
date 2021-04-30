data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
resource "aws_iam_policy" "UserPoolDomainSetterPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cognito-idp:CreateUserPoolDomain",
          "cognito-idp:DeleteUserPoolDomain",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "events:PutRule",
          "events:DeleteRule",
          "lambda:AddPermission",
          "events:PutTargets",
          "events:RemoveTargets",
          "lambda:RemovePermission"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "ESCognitoAuthSetterLambdaRole" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "es:UpdateElasticsearchDomainConfig",
          "es:DescribeElasticsearchDomain",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "events:PutRule",
          "events:DeleteRule",
          "lambda:AddPermission",
          "events:PutTargets",
          "events:RemoveTargets",
          "lambda:RemovePermission",
          "iam:PassRole"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "KibanaCustomizerLambdaRole" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "es:UpdateElasticsearchDomainConfig",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "events:PutRule",
          "events:DeleteRule",
          "lambda:AddPermission",
          "events:PutTargets",
          "events:RemoveTargets",
          "lambda:RemovePermission",
          "iam:PassRole",
          "waf:ListWebACLs",
          "waf-regional:ListWebACLs",
          "waf:ListRules",
          "waf-regional:ListRules",
          "wafv2:ListWebACLs"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "amazonESCognitoAccessPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cognito-idp:DescribeUserPool",
          "cognito-idp:CreateUserPoolClient",
          "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminUserGlobalSignOut",
          "cognito-idp:ListUserPoolClients",
          "cognito-identity:DescribeIdentityPool",
          "cognito-identity:UpdateIdentityPool",
          "cognito-identity:SetIdentityPoolRoles",
          "cognito-identity:GetIdentityPoolRoles"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "iam:PassedToService" : "cognito-identity.amazonaws.com"
          }
        }
      }
    ]
  })
}
#resource "aws_iam_role" "UserPoolDomainSetterLambdaRole" {
#  name                = "${var.projectPrefix}-UserPoolDomainSetterLambdaRole-${random_id.buildSuffix.hex}"
#  managed_policy_arns = [aws_iam_policy.UserPoolDomainSetterPolicy.arn]
#  assume_role_policy  = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#tags = {
#  Name  = "${var.projectPrefix}-UserPoolDomainSetterLambdaRole-${random_id.buildSuffix.hex}"
#  Owner = var.resourceOwner
#}
#}



###########lambda transformer######
resource "aws_iam_policy" "lambdaTransformerPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
}
resource "aws_iam_role" "lambdaTransformerExecutionRole" {
  name                = "${var.projectPrefix}-lambdaTransformerExecutionRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.lambdaTransformerPolicy.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name  = "${var.projectPrefix}-lambdaTransformerExecutionRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

###############


########delivery role###################

resource "aws_iam_policy" "logDeliveryPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cognito-idp:CreateUserPoolDomain",
          "cognito-idp:DeleteUserPoolDomain",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "events:PutRule",
          "events:DeleteRule",
          "lambda:AddPermission",
          "events:PutTargets",
          "events:RemoveTargets",
          "lambda:RemovePermission"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}
resource "aws_iam_role" "logDeliveryRole" {
  name                = "${var.projectPrefix}-logDeliveryRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.logDeliveryPolicy.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name  = "${var.projectPrefix}-KibanaCustomizerLambdaRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}



######################################
#resource "aws_iam_role" "ESCognitoAuthSetterLambdaRole" {
#  name                = "${var.projectPrefix}-ESCognitoAuthSetterLambdaRole-${random_id.buildSuffix.hex}"
#  managed_policy_arns = [aws_iam_policy.ESCognitoAuthSetterLambdaRole.arn]
#  assume_role_policy  = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#tags = {
#  Name  = "${var.projectPrefix}-UserPoolDomainSetterLambdaRole-${random_id.buildSuffix.hex}"
#  Owner = var.resourceOwner
#}
#}

resource "aws_iam_role" "KibanaCustomizerLambdaRole" {
  name                = "${var.projectPrefix}-KibanaCustomizerLambdaRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.KibanaCustomizerLambdaRole.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name  = "${var.projectPrefix}-KibanaCustomizerLambdaRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_lambda_function" "KibanaCustomizerLambda" {
  filename      = "lambda/KibanaCustomizerLambda.zip"
  function_name = "${var.projectPrefix}-KibanaCustomizerLambda-${random_id.buildSuffix.hex}"
  role          = aws_iam_role.KibanaCustomizerLambdaRole.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.7"
  memory_size   = 128
  timeout       = 90

  source_code_hash = filebase64sha256("lambda/KibanaCustomizerLambda.zip")
  environment {
    variables = {
      REGION     = "us-east-1"
      ACCOUNT_ID = data.aws_caller_identity.current.account_id
    }
  }
}

resource "aws_s3_bucket" "KinesisFirehoseS3Bucket" {
  bucket        = lower("${var.projectPrefix}KinesisFirehoseS3Bucket${random_id.buildSuffix.hex}")
  force_destroy = true
  tags = {
    Name  = "${var.projectPrefix}-KinesisFirehoseS3Bucket-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

#Cognito config
resource "aws_cognito_user_pool" "userPool" {
  name = lower("${var.projectPrefix}-userpool-${random_id.buildSuffix.hex}")
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]
  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true # false for "sub"
    required                 = true # true for "sub"
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.subDomain
  user_pool_id = aws_cognito_user_pool.userPool.id
}

#resource "aws_cognito_user_pool_client" "client" {
#  name = "${var.projectPrefix}-client-${random_id.buildSuffix.hex}"
#
#  user_pool_id = aws_cognito_user_pool.userPool.id
#}
resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${var.projectPrefix}-WAFKibanaIdentityPool-${random_id.buildSuffix.hex}"
  allow_unauthenticated_identities = false
  lifecycle {
    ignore_changes = [
      # Ignore changes to because this object is configured by the elasticsearch domain
      cognito_identity_providers
    ]
  }
  #    cognito_identity_providers {
  #      client_id               = aws_cognito_user_pool_client.client.id
  #      provider_name           = aws_cognito_user_pool.userPool.endpoint
  #      server_side_token_check = false
  #    }
}

resource "aws_iam_policy" "authenticatedPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "es:ESHttp*"
        ],
        "Resource" : [
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/waf-dashboards/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "authenticatedRole" {
  name                = "${var.projectPrefix}-authenticatedRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.UserPoolDomainSetterPolicy.arn]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "cognito-identity.amazonaws.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : aws_cognito_identity_pool.main.id
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "authenticated"
          }
        }
      }
    ]
  })
  tags = {
    Name  = "${var.projectPrefix}-authenticatedRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_iam_role" "CognitoAccessForAmazonESRole" {
  name                = "${var.projectPrefix}-CognitoAccessForAmazonESRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.amazonESCognitoAccessPolicy.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name  = "${var.projectPrefix}-CognitoAccessForAmazonESRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id
  roles = {
    "authenticated" = aws_iam_role.authenticatedRole.arn
  }
}

resource "null_resource" "cognito_user" {

  triggers = {
    user_pool_id = aws_cognito_user_pool.userPool.id
  }

  #no way to create a user in terraform yet
  provisioner "local-exec" {
    command = "aws --region us-east-1 cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool.userPool.id} --username ${var.userEmail}"
  }
}

resource "aws_elasticsearch_domain" "elasticsearchDomain" {
  domain_name           = var.subDomain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type            = "m5.large.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = false
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 100
    volume_type = "gp2"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  cognito_options {
    enabled          = true
    user_pool_id     = aws_cognito_user_pool.userPool.id
    identity_pool_id = aws_cognito_identity_pool.main.id
    role_arn         = aws_iam_role.CognitoAccessForAmazonESRole.arn
  }
  access_policies = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "es:*",
        "Principal" : {
          "AWS" : [aws_iam_role.KibanaCustomizerLambdaRole.arn]
        },
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/*",
      },
      {
        "Action" : "es:*",
        "Principal" : {
          "AWS" : [aws_iam_role.authenticatedRole.arn]
        },
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/*",
      }
    ]
  })
}

resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.elasticsearchDomain.domain_name

  access_policies = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "es:*",
        "Principal" : {
          "AWS" : [aws_iam_role.KibanaCustomizerLambdaRole.arn]
        },
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/*",
      },
      {
        "Action" : "es:*",
        "Principal" : {
          "AWS" : [aws_iam_role.authenticatedRole.arn]
        },
        "Effect" : "Allow",
        "Resource" : "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/*",
      }
    ]
  })
}

#Kinesis

resource "aws_iam_policy" "kinesisFirehoseDeliveryPolicy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Resource" : [
          aws_s3_bucket.KinesisFirehoseS3Bucket.arn,
          "${aws_s3_bucket.KinesisFirehoseS3Bucket.arn}/*"
        ],
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" : [
          "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:%FIREHOSE_DEFAULT_FUNCTION%:%FIREHOSE_DEFAULT_VERSION%",
          aws_lambda_function.lambdaLogTransformer.arn
        ],
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Action" : [
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut"
        ],
        "Resource" : [
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/*"
        ],
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Action" : [
          "es:ESHttpGet"
        ],
        "Resource" : [
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_all/_settings",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_cluster/stats",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/awswaf*/_mapping/superstore",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_nodes",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_nodes/stats",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_nodes/*/stats",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/_stats",
          "arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.subDomain}/awswaf*/_stats"
        ],
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/waflogs:log-stream:*"
        ],
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords"
        ],
        "Resource" : "arn:aws:kinesis:us-east-1:${data.aws_caller_identity.current.account_id}:stream/%FIREHOSE_STREAM_NAME%",
        "Effect" : "Allow",
        "Sid" : ""
      },
      {
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "s3.us-east-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:kinesis:arn" : "arn:aws:kinesis:us-east-1:${data.aws_caller_identity.current.account_id}:stream/%FIREHOSE_STREAM_NAME%"
          }
        },
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : [
          "arn:aws:kms:us-east-1:${data.aws_caller_identity.current.account_id}:key/%SSE_KEY_ARN%"
        ],
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "kinesisFirehoseDeliveryRole" {
  name                = "aws-waf-logs-kinesisFirehoseDeliveryRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.kinesisFirehoseDeliveryPolicy.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name  = "${var.projectPrefix}-kinesisFirehoseDeliveryRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_kinesis_firehose_delivery_stream" "kinesisFirehoseDeliveryStream" {
  name        = "aws-waf-logs-${var.projectPrefix}-${random_id.buildSuffix.hex}"
  destination = "elasticsearch"
  s3_configuration {
    role_arn           = aws_iam_role.kinesisFirehoseDeliveryRole.arn
    bucket_arn         = aws_s3_bucket.KinesisFirehoseS3Bucket.arn
    compression_format = "UNCOMPRESSED"
    buffer_size        = 50
    buffer_interval    = 60
    prefix             = "log/"
  }
  elasticsearch_configuration {
    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.lambdaLogTransformer.arn
        }
      }
    }
    domain_arn         = aws_elasticsearch_domain.elasticsearchDomain.arn
    index_name         = "awswaf"
    retry_duration     = 60
    role_arn           = aws_iam_role.kinesisFirehoseDeliveryRole.arn
    buffering_interval = 60
    buffering_size     = 5
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "deliverystream"
      log_stream_name = "elasticsearchDelivery"
    }
  }
}

resource "aws_lambda_function" "lambdaLogTransformer" {
  filename      = "lambda/lambdaLogTransformer.zip"
  function_name = "${var.projectPrefix}-lambdaLogTransformer-${random_id.buildSuffix.hex}"
  role          = aws_iam_role.lambdaTransformerExecutionRole.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  memory_size   = 128
  timeout       = 60

  source_code_hash = filebase64sha256("lambda/lambdaLogTransformer.zip")
}


resource "aws_lambda_function" "kibanaUpdate" {
  filename      = "aws-waf-dashboard/cloudformation-custom-resources/kibana-customizer-lambda.zip"
  function_name = "${var.projectPrefix}-kibanaUpdate-${random_id.buildSuffix.hex}"
  role          = aws_iam_role.KibanaCustomizerLambdaRole.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.7"
  memory_size   = 128
  timeout       = 160

  source_code_hash = filebase64sha256("aws-waf-dashboard/cloudformation-custom-resources/kibana-customizer-lambda.zip")
  environment {
    variables = {
      ES_ENDPOINT = aws_elasticsearch_domain.elasticsearchDomain.endpoint
      REGION      = "us-east-1"
      ACCOUNT_ID  = data.aws_caller_identity.current.account_id
    }
  }
}

resource "aws_cloudwatch_event_rule" "WAFv2Modification" {
  name        = "${var.projectPrefix}-WAFv2Modification-${random_id.buildSuffix.hex}"
  description = "WAF Dashboard - detects new WebACL and rules for WAFv2."
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "source" : ["aws.wafv2"],
    "detail" : {
      "eventSource" : ["wafv2.amazonaws.com"],
      "eventName" : ["CreateWebACL", "CreateRule"]
    }
  })
}

resource "aws_cloudwatch_event_target" "WAFv2Modification" {
  rule = aws_cloudwatch_event_rule.WAFv2Modification.name
  arn  = aws_lambda_function.kibanaUpdate.arn
}

resource "aws_cloudwatch_event_rule" "WAFGlobalModification" {
  name        = "${var.projectPrefix}-WAFGlobalModification-${random_id.buildSuffix.hex}"
  description = "WAF Dashboard - detects new WebACL and rules for WAFGlobalModification."
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "source" : ["aws.waf"],
    "detail" : {
      "eventSource" : ["waf.amazonaws.com"],
      "eventName" : ["CreateWebACL", "CreateRule"]
    }
  })
}

resource "aws_cloudwatch_event_target" "WAFGlobalModification" {
  rule = aws_cloudwatch_event_rule.WAFGlobalModification.name
  arn  = aws_lambda_function.kibanaUpdate.arn
}


resource "aws_cloudwatch_event_rule" "WAFRegionalModification" {
  name        = "${var.projectPrefix}-WAFRegionalModification-${random_id.buildSuffix.hex}"
  description = "WAF Dashboard - detects new WebACL and rules for WAFRegionalModification."
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "source" : ["aws.waf-regional"],
    "detail" : {
      "eventSource" : ["waf-regional.amazonaws.com"],
      "eventName" : ["CreateWebACL", "CreateRule"]
    }
  })
}

resource "aws_cloudwatch_event_target" "WAFRegionalModification" {
  rule = aws_cloudwatch_event_rule.WAFRegionalModification.name
  arn  = aws_lambda_function.kibanaUpdate.arn
}

resource "aws_lambda_permission" "kibanaUpdateWAFv2Permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kibanaUpdate.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.WAFv2Modification.arn
}


resource "aws_lambda_permission" "kibanaUpdateWAFGlobalPermission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kibanaUpdate.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.WAFGlobalModification.arn
}

resource "aws_lambda_permission" "kibanaUpdateWAFRegionalPermission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kibanaUpdate.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.WAFRegionalModification.arn
}



data "aws_lambda_invocation" "kibanaCustomizerLambda" {
  function_name = aws_lambda_function.KibanaCustomizerLambda.function_name

  input = jsonencode({
    "operation" : "create",
    "Region" : "us-east-1",
    "Host" : aws_elasticsearch_domain.elasticsearchDomain.endpoint,
    "AccountID" : data.aws_caller_identity.current.account_id
  })
}

output "result_entry" {
  value = jsondecode(data.aws_lambda_invocation.kibanaCustomizerLambda.result)
}

output "details" {
  value = "${aws_elasticsearch_domain.elasticsearchDomain.endpoint}, ${data.aws_caller_identity.current.account_id}"
}

output "dashboardLinkOutput" {
  description = "DNS record for the newly created site"
  value       = "https://${aws_elasticsearch_domain.elasticsearchDomain.endpoint}/_plugin/kibana/"
}
