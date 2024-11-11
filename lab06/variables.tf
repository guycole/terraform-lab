#
# Title:variables.tf
# Description: customize terraform deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
variable "aws_region" {
  description = "aws region"
  default     = "us-west-2"
}

variable "source_directory" {
  description = "source directory"
  default     = "/Users/gsc/Documents/github/terraform-lab/lab06"
}