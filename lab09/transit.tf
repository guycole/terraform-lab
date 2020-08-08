#
# Title:transit.tf
# Description: transit gateway
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_ec2_transit_gateway" "transit_gw" {
  auto_accept_shared_attachments = "enable"
  description = "lab9"

  tags = {
    Name = "transit"
    Environment = terraform.workspace
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_transit_attach" {
  subnet_ids = [module.vpc1.public_subnets[0], module.vpc1.public_subnets[1]]
  transit_gateway_id = aws_ec2_transit_gateway.transit_gw.id
  vpc_id = module.vpc1.vpc_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_transit_attach" {
  subnet_ids = [module.vpc2.private_subnets[0], module.vpc2.private_subnets[1]]
  transit_gateway_id = aws_ec2_transit_gateway.transit_gw.id
  vpc_id = module.vpc2.vpc_id
}

resource "aws_route" "transit_gw_route1" {
  route_table_id = module.vpc1.public_route_table_ids[0]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.transit_gw.id
}

resource "aws_route" "transit_gw_route2" {
  route_table_id = module.vpc2.private_route_table_ids[0]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.transit_gw.id
}