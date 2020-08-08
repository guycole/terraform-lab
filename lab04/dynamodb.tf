#
# Title:dynamodb.tf
# Description: dynamodb deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_dynamodb_table" "feature_table" {
  name           = "${terraform.workspace}-feature"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "FeatureKey"

  attribute {
    name = "FeatureKey"
    type = "S"
  }

  tags = {
    Name        = "feature-table"
    Environment = terraform.workspace
  }
}

resource "aws_dynamodb_table_item" "audit_sqs_enable" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "audit_sqs_enable"},
  "FeatureValue": {"S": "false"}
}
EOF
}

resource "aws_dynamodb_table_item" "apigw_s3_enable" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "apigw_s3_enable"},
  "FeatureValue": {"S": "false"}
}
EOF
}

resource "aws_dynamodb_table_item" "firebase_sns_enable" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "firebase_sns_enable"},
  "FeatureValue": {"S": "false"}
}
EOF
}

resource "aws_dynamodb_table_item" "admin_s3_enable" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "admin_s3_enable"},
  "FeatureValue": {"S": "false"}
}
EOF
}

resource "aws_dynamodb_table_item" "logging_level" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "logging_level"},
  "FeatureValue": {"S": "info"}
}
EOF
}

resource "aws_dynamodb_table_item" "feature_test_target" {
  table_name = aws_dynamodb_table.feature_table.name
  hash_key   = aws_dynamodb_table.feature_table.hash_key

  item = <<EOF
{
  "FeatureKey": {"S": "test_target"},
  "FeatureValue": {"S": "test_value"}
}
EOF
}
