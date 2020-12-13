#
# Title:vpc.tf
# Description: demonstration VPC (2x)
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_vpc" "db-vpc" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_subnet" "db-vpc-az1" {
  vpc_id                  = aws_vpc.db-vpc.id
  cidr_block              = "10.100.100.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
}

resource "aws_subnet" "db-vpc-az2" {
  vpc_id                  = aws_vpc.db-vpc.id
  cidr_block              = "10.100.101.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"
}
