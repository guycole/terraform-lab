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
  identifier           = "traveler-db"
  instance_class       = "db.t2.micro"
  name                 = "jaded-traveler"
#  parameter_group_name = "default.postgres-9-6"
  skip_final_snapshot  = true
  storage_encrypted    = false
  storage_type         = "gp2"
  username             = "usertest"
  password             = "bigsekret"
}

#resource "aws_db_parameter_group" "test" {
#  family = "postgres9.16.19"
#  name = "testaroo"
#
#  parameter {
#    name  = "character_set_server"
#    value = "utf8"
#  }
#
#  parameter {
#    name  = "character_set_client"
#    value = "utf8"
#  }
#}