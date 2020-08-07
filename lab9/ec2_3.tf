#
# Title:ec2_3.tf
# Description: ec2 vpc2 private instance
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  ec2_name3 = lookup({
    lab-development = "lab9-ec2-dev3",
    lab-production  = "lab9-ec2-prod3"
  }, terraform.workspace, "default")
}

resource "aws_security_group" "ec2_sg3" {
  description = local.ec2_name3
  name        = local.ec2_name3
  vpc_id      = module.vpc2.vpc_id

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
    Name = local.ec2_name3
  }
}

data "aws_iam_policy_document" "ec2_policy_document3" {
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::bogus"]
  }
}

resource "aws_iam_policy" "ec2_policy3" {
  name        = local.ec2_name3
  description = "ec2 policy"
  policy      = data.aws_iam_policy_document.ec2_policy_document3.json
}

data "aws_iam_policy_document" "ec2_assume_policy_document3" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role3" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy_document3.json
  name               = local.ec2_name3

  tags = {
    Name = local.ec2_name3
  }
}

resource "aws_iam_policy_attachment" "ec2_policy_attach3" {
  name       = local.ec2_name3
  roles      = [aws_iam_role.ec2_role3.name]
  policy_arn = aws_iam_policy.ec2_policy3.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile3" {
  name = local.ec2_name3
  role = aws_iam_role.ec2_role3.name
}

resource "aws_instance" "ec2_3" {
  # ohio Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-07c8bc5c1ce9598c3 (64-bit x86) / ami-09a67037138f86e67 (64-bit Arm)
  ami = "ami-07c8bc5c1ce9598c3"
  associate_public_ip_address = false
  availability_zone           = "us-east-2a"
  depends_on                  = [module.vpc2]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile3.name
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = module.vpc2.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg3.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion1.public_ip} > ec2_ip3.txt"
  }

  tags = {
    Environment = terraform.workspace
    Name        = local.ec2_name3
  }
}