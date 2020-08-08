#
# Title:redshift.tf
# Description: demonstration redshift cluster
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
resource "aws_redshift_cluster" "redshift1" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "tf_demo1"
  master_username    = "master"
  master_password    = "BogusBogus2"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
}