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

locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}

resource "aws_db_subnet_group" "_" {
  name       = "${local.resource_name_prefix}-${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "_" {
  identifier = "${local.resource_name_prefix}-${var.identifier}"

  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  db_subnet_group_name    = aws_db_subnet_group._.id
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  multi_az                = var.multi_az
  name                    = var.name
  username                = var.username
  password                = var.password
  port                    = var.port
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = var.storage_encrypted
  storage_type            = var.storage_type

  vpc_security_group_ids = ["${aws_security_group._.id}"]

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade

  final_snapshot_identifier = var.final_snapshot_identifier
  snapshot_identifier       = var.snapshot_identifier
  skip_final_snapshot       = var.skip_final_snapshot

  performance_insights_enabled = var.performance_insights_enabled 
}