#
# Title:s3.tf
# Description: demo s3 bucket
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  bucket_name = format("%s-lab6", terraform.workspace)

  error_html = format("%s/%s", var.source_directory, "error.html")
  index_html = format("%s/%s", var.source_directory, "index.html")
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_kms_key" "lab6" {
  description             = "lab6"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
        }, {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab6" {
  bucket = aws_s3_bucket.lab6.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.lab6.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "lab6" {
  #  acl    = "public-read"
  bucket = local.bucket_name
  #  policy = data.aws_iam_policy_document.bucket_policy.json


  tags = {
    Key = "Value"
  }
}

resource "aws_s3_object" "error_upload" {
  bucket       = aws_s3_bucket.lab6.id
  content_type = "text/html"
  key          = "error.html"
  source       = local.error_html
  etag         = filemd5(local.error_html)
}

resource "aws_s3_object" "index_upload" {
  bucket       = aws_s3_bucket.lab6.id
  content_type = "text/html"
  key          = "index.html"
  source       = local.index_html
  etag         = filemd5(local.index_html)
}