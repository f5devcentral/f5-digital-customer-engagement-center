resource "aws_iam_role" "authenticated" {
  name = "${var.name}-AUTH-ROLE"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
        "StringEquals": {
        "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
        "cognito-identity.amazonaws.com:amr": "authenticated"
        }
    }
    }
]
}
EOF

}

resource "aws_iam_role_policy" "authenticated" {
  name = "authenticated_policy"
  role = aws_iam_role.authenticated.id

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
  "Effect": "Allow",
  "Action": [
      "mobileanalytics:PutEvents",
      "cognito-sync:*"
  ],
  "Resource": [
      "*"
  ]
  }
]
}
EOF
}

resource "aws_iam_role" "unauthenticated" {
  name = "${var.name}-UNAUTH-ROLE"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
  "Effect": "Allow",
  "Principal": {
      "Federated": "cognito-identity.amazonaws.com"
  },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
      "StringEquals": {
      "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.identity_pool.id}"
      },
      "ForAnyValue:StringLike": {
      "cognito-identity.amazonaws.com:amr": "unauthenticated"
      }
  }
  }
]
}
EOF
}

resource "aws_iam_role_policy" "unauthenticated" {
  name = "authenticated_policy"
  role = aws_iam_role.authenticated.id

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
  "Effect": "Allow",
  "Action": [
      "mobileanalytics:PutEvents",
      "cognito-sync:*"
  ],
  "Resource": [
      "*"
  ]
  }
]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id
  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }
}