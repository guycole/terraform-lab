#
# Title:s3.tf
# Description: create a web site public bucket
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  bucket_name = format("%s-lab1", terraform.workspace)

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

resource "aws_s3_bucket" "lab1_bucket" {
  acl    = "public-read"
  bucket = local.bucket_name
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "s3"
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_object" "error_upload" {
  bucket       = aws_s3_bucket.lab1_bucket.id
  content_type = "text/html"
  key          = "error.html"
  source       = local.error_html
  etag         = filemd5(local.error_html)
}

resource "aws_s3_bucket_object" "index_upload" {
  bucket       = aws_s3_bucket.lab1_bucket.id
  content_type = "text/html"
  key          = "index.html"
  source       = local.index_html
  etag         = filemd5(local.index_html)
}