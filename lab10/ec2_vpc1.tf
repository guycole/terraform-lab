#
# Title:ec2_vpc1.tf
# Description: ec2 vpc1
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_security_group" "vpc1-sg" {
  name_prefix = "vpc1-"
  description = "Default security group for all instances in VPC1"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.vpc1.cidr_block,
      aws_vpc.vpc2.cidr_block,
    ]
  }

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
}

resource "aws_instance" "ec2-vpc1-az1" {
  # ohio Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-07c8bc5c1ce9598c3 (64-bit x86) / ami-09a67037138f86e67 (64-bit Arm)
  ami = "ami-07c8bc5c1ce9598c3"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.vpc1-az1.id
  vpc_security_group_ids = [aws_security_group.vpc1-sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2-vpc1-az1.public_ip} > ec2_vpc1-az1.txt"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.key_pair_path)
    }

    inline = [
      "sudo yum -y update",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_instance" "ec2-vpc1-az2" {
  # ohio Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-07c8bc5c1ce9598c3 (64-bit x86) / ami-09a67037138f86e67 (64-bit Arm)
  ami = "ami-07c8bc5c1ce9598c3"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.vpc1-az2.id
  vpc_security_group_ids = [aws_security_group.vpc1-sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2-vpc1-az2.public_ip} > ec2_vpc1-az2.txt"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.key_pair_path)
    }

    inline = [
      "sudo yum -y update",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo systemctl start nginx"
    ]
  }
}