############
# Create IAM Role for controller VM to pull secret from SecretManager and access S3 bucket to get install file
############

data "aws_iam_policy_document" "controller_role" {
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

resource "aws_iam_role" "controller_role" {
  name               = format("%s-controller_role-%s", var.projectPrefix, random_id.id.hex)
  assume_role_policy = data.aws_iam_policy_document.controller_role.json

  tags = {
    poc_name = var.projectPrefix
  }
}


resource "aws_iam_instance_profile" "controller_role" {
  name = format("%s-controller_role-%s", var.projectPrefix, random_id.id.hex)
  role = aws_iam_role.controller_role.name
}

data "aws_iam_policy_document" "controller_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.controller_secrets.id
    ]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucketId}/*"
    ]
  }
}

resource "aws_iam_role_policy" "controller_policy" {
  name   = format("%s-controller_policy-%s", var.projectPrefix, random_id.id.hex)
  role   = aws_iam_role.controller_role.id
  policy = data.aws_iam_policy_document.controller_policy.json
}
