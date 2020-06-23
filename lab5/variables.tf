#
# Title:variables.tf
# Description: customize terraform deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
variable "aws_region" {
  description = "aws region"
  default     = "us-west-2"
}

variable "lab5_users" {
  description = "lab5 users"
  type = set(string)
  default = ["user1", "user2", "user3"]
}