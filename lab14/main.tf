#
# Title:main.tf
# Description: main
# Development Environment: OS X 10.13.6/Terraform v1.3.2
# works after gcloud auth application-default login
#
provider "google" {
  #credentials = file("account.json")
  project = "playpen-426404"
  region  = "us-west1"
}

terraform {
  backend "s3" {
    bucket               = "terraform.braingang.net"
    encrypt              = true
    key                  = "terraform.tfstate"
    profile              = "terraform_braingang"
    region               = "us-west-2"
    workspace_key_prefix = "terraform-lab14"
  }
}