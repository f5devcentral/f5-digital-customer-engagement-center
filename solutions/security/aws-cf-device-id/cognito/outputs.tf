output "cognito_map" {
  description = "cognito info"
  value       = { "user_pool"        = aws_cognito_user_pool.user_pool.id
    "identity_pool"    = aws_cognito_identity_pool.identity_pool.id
    "auth_arn"         = aws_iam_role.authenticated.arn
    "domain"           = "${aws_cognito_user_pool_domain.user_pool_domain.domain}.auth.${var.awsRegion}.amazoncognito.com"
  }
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.identity_pool.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.client.id
}