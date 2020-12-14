#
# Title:lambda.tf
# Description: 
# Development Environment: Terraform v0.13.2
#
locals {
  local_file_name = "${var.local_lambda_path}/test-lambda.zip"
}

resource "aws_lambda_function" "lambda_deploy" {
  description      = "test lambda"
  filename         = local.local_file_name
  function_name    = terraform.workspace
  handler          = "test_lambda.lambda_handler"
  role             = aws_iam_role.lambda_assumable_role.arn
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(local.local_file_name)
  timeout = 8

  tags = {
    project   = "test"
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${terraform.workspace}"
  retention_in_days = 14
}
#
resource "aws_iam_role" "lambda_assumable_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
  name               = "${terraform.workspace}-lambda-assume-role"
  path               = "/"
}
#
data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
#
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
#
resource "aws_iam_policy" "lambda_policy" {
  name   = "${terraform.workspace}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}
#
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_assumable_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
#