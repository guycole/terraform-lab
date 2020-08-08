#
# Title:vpc.tf
# Description: demonstration VPC (2x)
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_vpc" "vpc1" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.200.0.0/16"
}

resource "aws_internet_gateway" "vpc1-gw" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_internet_gateway" "vpc2-gw" {
  vpc_id = aws_vpc.vpc2.id
}

# default route to IGW
resource "aws_route" "vpc1-gw-route" {
  route_table_id         = aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1-gw.id
}

# default route to IGW
resource "aws_route" "vpc2-gw-route" {
  route_table_id         = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc2-gw.id
}

resource "aws_subnet" "vpc1-az1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.100.100.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

resource "aws_subnet" "vpc1-az2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.100.101.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

resource "aws_subnet" "vpc2-az1" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.200.200.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

resource "aws_subnet" "vpc2-az2" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.200.201.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}
