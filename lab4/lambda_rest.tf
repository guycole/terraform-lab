#
# Title:lambda_rest.tf
# Description: lambda rest deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#

locals {
  bucket_key  = "lab4_rest.zip"
  bucket_name = format("%s-lab4", terraform.workspace)
  rest_zip         = format("%s/%s", var.source_directory, "lambda/lab4_rest.zip")
}

resource "aws_s3_bucket_object" "lambda_rest_upload" {
  bucket = local.bucket_name
  key    = local.bucket_key
  source = local.rest_zip
  etag   = filemd5(local.rest_zip)
}

data "aws_iam_policy_document" "lambda_rest_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_rest_assumable_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_rest_assume_policy.json
  name               = "${terraform.workspace}-lambda-rest-assume-role"
  path               = "/"
}

data "aws_iam_policy_document" "lambda_rest_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["dynamodb:DeleteItem", "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query", "dynamodb:Scan", "dynamodb:UpdateItem"]
    resources = ["arn:aws:dynamodb:*:*:*"]
  }

  statement {
    actions   = ["sns:Publish"]
    resources = ["arn:aws:sns:*:*:*"]
  }

  statement {
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:*:*:*"]
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "lambda_rest_policy" {
  name   = "${terraform.workspace}-lambda-rest-policy"
  policy = data.aws_iam_policy_document.lambda_rest_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_rest_policy_attach" {
  role       = aws_iam_role.lambda_rest_assumable_role.name
  policy_arn = aws_iam_policy.lambda_rest_policy.arn
}

resource "aws_cloudwatch_log_group" "lambda_rest_log_group" {
  name              = "/aws/lambda/${terraform.workspace}-rest"
  retention_in_days = 14
}

resource "aws_lambda_function" "lambda_rest" {
  s3_bucket     = local.bucket_name
  s3_key        = local.bucket_key
  function_name = "${terraform.workspace}-rest"
  handler       = "rest.handler"
  role          = aws_iam_role.lambda_rest_assumable_role.arn
  description   = "lab4 REST handler"
  runtime       = "python3.8"
  timeout       = "9"

  source_code_hash = filebase64sha256(local.rest_zip)

  tags = {
    Name        = "lambda_rest"
    Environment = terraform.workspace
  }
}