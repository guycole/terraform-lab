#
# Title:variables.tf
# Description: customize terraform deployment
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
variable "aws_region" {
  description = "aws region"
  default     = "us-east-2"
}

variable "key_pair" {
  description = "ec2 key pair name"
  default     = "demokp"
}

variable "key_pair_path" {
  description = "fully qualified file name"
  default     = "/Users/gsc/Google Drive/amazon/braingang/demokp.pem"
}