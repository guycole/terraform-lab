#
# Title:peering.tf
# Description: vpc peering
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_vpc_peering_connection" "vpc1to2" {
  peer_vpc_id = aws_vpc.vpc2.id
  vpc_id = aws_vpc.vpc1.id
  auto_accept = true
}

resource "aws_route" "route1to2" {
  route_table_id = aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1to2.id
}

resource "aws_route" "route2to1" {
  route_table_id = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1to2.id
}