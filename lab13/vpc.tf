#
# Title:vpc.tf
# Description: demonstration VPC
# Development Environment: OS X 11.0.1/Terraform v0.13.2
#
locals {
  vpc_name1 = lookup({
    lab-development = "lab13-vpc-dev1",
    lab-production  = "lab13-vpc-prod1"
  }, terraform.workspace, "default")
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.100.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "vpc1-gw" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "vpc1-route" {
  vpc_id = aws_vpc._.id

  dynamic "route" {
    for_each = var.route

    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = route.value.gateway_id
      instance_id    = route.value.instance_id
      nat_gateway_id = route.value.nat_gateway_id
    }
  }
}

resource "aws_route_table_association" "vpc1-route2net" {
  count          = length(var.subnet_ids)

  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table._.id
}