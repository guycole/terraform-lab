#
# Title:s3.tf
# Description: create lambda bucket
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  bucket_name = format("%s-lab4", terraform.workspace)
}

resource "aws_s3_bucket" "lab4_bucket" {
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
