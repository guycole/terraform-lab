resource "aws_iam_role" "demo-role" {
    name = "demo-roles"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy1a" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.demo-role.name
}

resource "aws_iam_role_policy_attachment" "policy2a" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.demo-role.name
}

resource "aws_iam_role_policy_attachment" "policy3a" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    role = aws_iam_role.demo-role.name
}

resource "aws_iam_group" "demo-group" {
    name = "demo-group"
}

resource "aws_iam_group_policy_attachment" "policy1b" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    group = aws_iam_group.demo-group.name
}

resource "aws_iam_group_policy_attachment" "policy2b" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    group = aws_iam_group.demo-group.name
}

resource "aws_iam_group_policy_attachment" "policy3b" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    group = aws_iam_group.demo-group.name
}
