###########lambda transformer######
data aws_iam_policy_document assume_role_policy_doc {
  statement {
    sid    = "AllowAwsToAssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "lambdaEdgePolicy" {
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

resource "aws_iam_role" "lambdaEdgeRole" {
  name                = "${var.projectPrefix}-lambdaEdgeRole-${random_id.buildSuffix.hex}"
  managed_policy_arns = [aws_iam_policy.lambdaEdgePolicy.arn]
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy_doc.json
  tags = {
    Name  = "${var.projectPrefix}-lambdaEdgeRole-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_lambda_function" "extractUsername" {
  filename      = "lambda/extractUsername/extractUsername.zip"
  function_name = "${var.projectPrefix}-extractUsername-${random_id.buildSuffix.hex}"
  role          = aws_iam_role.lambdaEdgeRole.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  memory_size   = 128
  timeout       = 1
  publish = true
  source_code_hash = filebase64sha256("lambda/extractUsername/extractUsername.zip")
}
