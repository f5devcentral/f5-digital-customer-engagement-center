#save secrets for nginx in AWS Secret Manager
resource "aws_secretsmanager_secret" "nginx_secrets" {
  name        = "nginx_secrets_${random_id.id.hex}"
  description = "nginx_secrets"
  tags = {
    project = var.prefix
  }
}

resource "aws_secretsmanager_secret_version" "nginx_secrets" {
  secret_id = aws_secretsmanager_secret.nginx_secrets.id
  #secret_string = data.template_file.nginx_secrets.rendered
  secret_string = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}",
  "cuser": "${var.controllerAccount}",
  "cpass": "${var.controllerPass}"
  }
  EOF

}
