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
  timeout          = 8

  vpc_config {
    subnet_ids         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
    security_group_ids = [aws_security_group.postgres_sg.id]
  }

  tags = {
    project = "test"
  }
}

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

resource "aws_iam_role" "lambda_assumable_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
  name               = "${terraform.workspace}-lambda-assume-role"
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach1" {
  role       = aws_iam_role.lambda_assumable_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_assumable_role.name
}

data "aws_iam_policy_document" "lambda_log_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${terraform.workspace}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_log_policy.json
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${terraform.workspace}"
  retention_in_days = 14
}