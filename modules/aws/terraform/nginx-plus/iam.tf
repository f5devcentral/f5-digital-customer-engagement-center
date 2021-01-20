############
# Create IAM Role for nginx VM to pull secret from SecretManager
############

data "aws_iam_policy_document" "nginx_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nginx_role" {
  name               = format("%s-nginx_role-%s", var.prefix, random_id.id.hex)
  assume_role_policy = data.aws_iam_policy_document.nginx_role.json

  tags = {
    project = var.prefix
  }
}


resource "aws_iam_instance_profile" "nginx_role" {
  name = format("%s-nginx_role-%s", var.prefix, random_id.id.hex)
  role = aws_iam_role.nginx_role.name
}

data "aws_iam_policy_document" "nginx_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.nginx_secrets.id
    ]
  }
}

resource "aws_iam_role_policy" "nginx_policy" {
  name   = format("%s-nginx_policy-%s", var.prefix, random_id.id.hex)
  role   = aws_iam_role.nginx_role.id
  policy = data.aws_iam_policy_document.nginx_policy.json
}
