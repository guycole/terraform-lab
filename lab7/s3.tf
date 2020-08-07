#
# Title:s3.tf
# Description: create kops bucket
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  bucket_name = format("%s-lab7", terraform.workspace)
}

resource "aws_s3_bucket" "lab7_bucket" {
  bucket = local.bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = false
  }

  tags = {
    Name        = "s3"
    Environment = terraform.workspace
  }
}
