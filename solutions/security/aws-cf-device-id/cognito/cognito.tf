resource "aws_cognito_user_pool" "user_pool" {
  name = var.name

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  auto_verified_attributes = ["email"]
  mfa_configuration = "OFF"
  username_attributes = ["email"]

  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = true
    require_uppercase = true
    temporary_password_validity_days = 90
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "user_client_${var.name}"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.domainName
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "${var.name}_identity_pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id       = aws_cognito_user_pool_client.client.id
    provider_name   = aws_cognito_user_pool.user_pool.endpoint
  }

  lifecycle {ignore_changes = [cognito_identity_providers]}
}