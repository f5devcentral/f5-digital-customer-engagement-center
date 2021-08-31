# Create IAM Role

data "aws_iam_policy_document" "bigip_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bigip_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeAddresses",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeNetworkInterfaceAttribute",
      "ec2:DescribeRouteTables",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "ec2:CreateRoute",
      "ec2:ReplaceRoute"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging"
    ]
    resources = [aws_s3_bucket.main.arn]
    effect    = "Allow"
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "bigip_role" {
  name               = format("%s-bigip-role-%s", var.projectPrefix, random_id.buildSuffix.hex)
  assume_role_policy = data.aws_iam_policy_document.bigip_role.json
  inline_policy {
    name   = "bigip-policy"
    policy = data.aws_iam_policy_document.bigip_policy.json
  }
  tags = {
    Name  = format("%s-bigip-role-%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner = var.resourceOwner
  }
}

resource "aws_iam_instance_profile" "bigip_profile" {
  name = format("%s-bigip-profile-%s", var.projectPrefix, random_id.buildSuffix.hex)
  role = aws_iam_role.bigip_role.name
}

// IAM User for 12.1.x instances

// resource "aws_iam_user" "bigip" {
//   name = "bigip_user"
//   force_destroy = true
//   tags = {
//     Name  = format("%s-bigip-role-%s", var.projectPrefix, random_id.buildSuffix.hex)
//     Owner = var.resourceOwner
//   }
// }
//
// resource "aws_iam_access_key" "bigip" {
//   user = aws_iam_user.bigip.name
// }
//
// resource "aws_iam_user_policy" "bigip_user_policy" {
//   name = "bigip_policy"
//   user = aws_iam_user.bigip.name
//
//   policy = <<EOF
// {
//   "Version": "2012-10-17",
//   "Statement": [
//       {
//           "Effect": "Allow",
//           "Action": [
//           "ec2:describeinstancestatus",
//           "ec2:describenetworkinterfaces",
//           "ec2:assignprivateipaddresses"
//           ],
//           "Resource": "*"
//       }
//   ]
//  }
// EOF
// }
