#
# Title:web.tf
# Description: web server
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  web_name = lookup({
    lab-development = "lab3-web-dev",
    lab-production  = "lab3-web-prod"
  }, terraform.workspace, "default")
}

resource "aws_security_group" "web_sg" {
  description = "lab3 web security group"
  name        = local.web_name
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Environment = terraform.workspace
    Name        = local.web_name
  }
}

data "aws_iam_policy_document" "web_policy_document" {
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "web_policy" {
  name        = local.web_name
  description = "web policy"
  policy      = data.aws_iam_policy_document.web_policy_document.json
}

data "aws_iam_policy_document" "web_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web_role" {
  assume_role_policy = data.aws_iam_policy_document.web_assume_policy_document.json
  name               = local.web_name

  tags = {
    Environment = terraform.workspace
    Name        = local.web_name
  }
}

resource "aws_iam_policy_attachment" "web_policy_attach" {
  name       = local.web_name
  roles      = [aws_iam_role.web_role.name]
  policy_arn = aws_iam_policy.web_policy.arn
}

resource "aws_iam_instance_profile" "web_instance_profile" {
  name = local.web_name
  role = aws_iam_role.web_role.name
}

resource "aws_instance" "web" {
  ami                         = "ami-061392db613a6357b"
  associate_public_ip_address = false
  availability_zone           = "us-west-2b"
  depends_on                  = [module.vpc]
  iam_instance_profile        = aws_iam_instance_profile.web_instance_profile.name
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > web_ip.txt"
  }

  tags = {
    Environment = terraform.workspace
    Name        = local.web_name
  }
}
