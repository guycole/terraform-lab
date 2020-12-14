#
# Title:vpc.tf
# Description: demonstration VPC
# Development Environment: OS X 11.0.1/Terraform v0.13.2
#
locals {
  vpc_name = lookup({
    lab-development = "lab13-vpc-dev",
    lab-production  = "lab13-vpc-prod"
  }, terraform.workspace, "default")
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name

  cidr = "192.168.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["192.168.1.0/24", "192.168.2.0/24"]
  private_subnets = ["192.168.3.0/24", "192.168.4.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_s3_endpoint     = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false

  tags = {
    Name = local.vpc_name
  }

  private_subnet_tags = {
    Name = "lab13-private"
  }

  public_subnet_tags = {
    Name = "lab13-public"
  }

  vpc_tags = {
    Name = local.vpc_name
  }
}