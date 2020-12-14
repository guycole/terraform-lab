#
# Title:rds.tf
# Description: demonstration RDS (postgresql)
# Development Environment: OS X 11.0.1/Terraform v0.13.2
#
resource "aws_security_group" "postgres_sg" {
  name = "test-rds-sg"

  description = "postgres"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "lab13"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  engine                 = "postgres"
  engine_version         = "9.6.19"
  identifier             = "lab-db"
  instance_class         = "db.t2.micro"
  name                   = "lab13"
  skip_final_snapshot    = true
  storage_encrypted      = false
  storage_type           = "gp2"
  username               = "usertest"
  password               = "bigsekret"
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
}