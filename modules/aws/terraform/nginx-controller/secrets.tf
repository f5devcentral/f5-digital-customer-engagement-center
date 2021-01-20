resource "aws_secretsmanager_secret" "controller_secrets" {
  name        = "controller_secrets_${random_id.id.hex}"
  description = "controller_secrets"
  tags = {
    poc_name = var.prefix
  }
}

resource "aws_secretsmanager_secret_version" "controller_secrets" {
  secret_id     = aws_secretsmanager_secret.controller_secrets.id
  secret_string = <<-EOF
  {
  "license": ${jsonencode(var.controllerLicense)},
  "user": "${var.controllerAccount}",
  "pass": "${var.controllerPass}",
  "dbpass": "${var.dbuser}",
  "dbuser": "${var.dbpass}"
  }
  EOF

}
