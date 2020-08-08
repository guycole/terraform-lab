#
# Title:variables.tf
# Description: customize terraform deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
variable "fastly_api_key" {
  description = "fastly api key"
  default = "bogus"
}

variable "aws_region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "source_directory" {
  description = "source directory"
  default     = "/Users/gsc/IdeaProjects/terraform-lab/lab2"
  #  default     = "/home/gsc/github/terraform-lab/lab2"
}