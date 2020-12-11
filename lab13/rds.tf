#
# Title:rds.tf
# Description: demonstration RDS (postgresql)
# Development Environment: OS X 11.0.1/Terraform v0.13.2
#
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
#  db_subnet_group_name = "db-subnetgrp"
  engine               = "postgres"
  engine_version       = "9.6.19"
  identifier           = "devdb1"
  instance_class       = "db.t2.micro"
  name                 = "name"
#  parameter_group_name = "default.postgres-9-6"
  skip_final_snapshot  = true
  storage_encrypted    = true
  storage_type         = "gp2"
  username             = "user"
  password             = "bigsekret"
}

resource "aws_db_parameter_group" "test" {
  family = "postgres9.16.19"
}
