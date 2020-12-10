#
# Title:main.tf
# Description: main
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
provider "aws" {
  profile = lookup({
    lab-development = "terraform_braingang",
    lab-production  = "terraform_braingang"
  }, terraform.workspace, "default")

  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket               = "terraform.braingang.net"
    encrypt              = true
    key                  = "terraform.tfstate"
    profile              = "terraform_braingang"
    region               = "us-west-2"
    workspace_key_prefix = "terraform-lab13"
  }
}