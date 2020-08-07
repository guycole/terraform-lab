#
# Title:bastion1.tf
# Description: bastion server, only accepts ssh
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  bastion_name1 = lookup({
    lab-development = "lab9-bastion-dev1",
    lab-production  = "lab9-bastion-prod1"
  }, terraform.workspace, "default")
}

resource "aws_security_group" "bastion_sg1" {
  description = local.bastion_name1
  name        = local.bastion_name1
  vpc_id      = module.vpc1.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.bastion_name1
  }
}

data "aws_iam_policy_document" "bastion_policy_document1" {
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::bogus"]
  }
}

resource "aws_iam_policy" "bastion_policy1" {
  name        = local.bastion_name1
  description = "bastion policy"
  policy      = data.aws_iam_policy_document.bastion_policy_document1.json
}

data "aws_iam_policy_document" "bastion_assume_policy_document1" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role1" {
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_policy_document1.json
  name               = local.bastion_name1

  tags = {
    Name = local.bastion_name1
  }
}

resource "aws_iam_policy_attachment" "bastion_policy_attach" {
  name       = local.bastion_name1
  roles      = [aws_iam_role.bastion_role1.name]
  policy_arn = aws_iam_policy.bastion_policy1.arn
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = local.bastion_name1
  role = aws_iam_role.bastion_role1.name
}

resource "aws_instance" "bastion1" {
  # ohio Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-07c8bc5c1ce9598c3 (64-bit x86) / ami-09a67037138f86e67 (64-bit Arm)
  ami = "ami-07c8bc5c1ce9598c3"
  associate_public_ip_address = true
  availability_zone           = "us-east-2a"
  depends_on                  = [module.vpc1]
  iam_instance_profile        = aws_iam_instance_profile.bastion_instance_profile.name
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = module.vpc1.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg1.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion1.public_ip} > bastion_ip1.txt"
  }

  tags = {
    Environment = terraform.workspace
    Name        = local.bastion_name1
  }
}