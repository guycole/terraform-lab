#
# Title:vpc.tf
# Description: demonstration VPC (2x)
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  vpc_name1 = lookup({
    lab-development = "lab9-vpc-dev1",
    lab-production  = "lab9-vpc-prod1"
  }, terraform.workspace, "default")

  vpc_name2 = lookup({
    lab-development = "lab9-vpc-dev2",
    lab-production  = "lab9-vpc-prod2"
  }, terraform.workspace, "default")
}

module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name1

  cidr = "10.1.0.0/16"

  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"]

#  enable_nat_gateway     = true
#  single_nat_gateway     = true
#  one_nat_gateway_per_az = false
#  enable_s3_endpoint     = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = local.vpc_name1
  }

  vpc_tags = {
    Name = local.vpc_name1
  }
}

module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name2

  cidr = "10.2.0.0/16"

  azs = ["us-east-2a", "us-east-2b"]
  private_subnets = ["10.2.0.0/24", "10.2.1.0/24"]

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = local.vpc_name2
  }

  vpc_tags = {
    Name = local.vpc_name2
  }
}