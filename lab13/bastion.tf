#
# Title:bastion.tf
# Description: bastion server, only accepts ssh
# Development Environment: OS X 11.0.1/Terraform v0.13.2
#
locals {
  bastion_name = lookup({
    lab-development = "lab13-bastion-dev",
    lab-production  = "lab13-bastion-prod"
  }, terraform.workspace, "default")
}

resource "aws_security_group" "bastion_sg" {
  description = local.bastion_name
  name        = local.bastion_name
  vpc_id      = module.vpc.vpc_id

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
    Name = local.bastion_name
  }
}

data "aws_iam_policy_document" "bastion_policy_document" {
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "bastion_policy" {
  name        = local.bastion_name
  description = "bastion policy"
  policy      = data.aws_iam_policy_document.bastion_policy_document.json
}

data "aws_iam_policy_document" "bastion_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_policy_document.json
  name               = local.bastion_name

  tags = {
    Name = local.bastion_name
  }
}

resource "aws_iam_policy_attachment" "bastion_policy_attach" {
  name       = local.bastion_name
  roles      = [aws_iam_role.bastion_role.name]
  policy_arn = aws_iam_policy.bastion_policy.arn
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = local.bastion_name
  role = aws_iam_role.bastion_role.name
}

resource "aws_instance" "bastion" {
  # Oregon Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-0c5204531f799e0c6 (64-bit x86)
  # Oregon Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-0e472933a1395e172 (64-bit x86)
  # ami                         = "ami-0c5204531f799e0c6"
  ami                         = "ami-0e472933a1395e172"
  associate_public_ip_address = true
  availability_zone           = "us-west-2a"
  depends_on                  = [module.vpc]
  iam_instance_profile        = aws_iam_instance_profile.bastion_instance_profile.name
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion.public_ip} > bastion_ip.txt"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = file(var.key_pair_path)
    }

    inline = [
      "sudo yum -y update",
      "sudo yum -y install git",
      "sudo yum -y install python3",
      "sudo yum -y install postgresql",
    ]
  }

  tags = {
    Environment = terraform.workspace
    Name        = local.bastion_name
  }
}