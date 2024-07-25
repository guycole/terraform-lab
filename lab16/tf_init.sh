#
# Title:tf_init.sh
# Description: terraform setup
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
PATH=/bin:/usr/bin:/etc:/usr/local/bin:$HOME/local/bin; export PATH
#
export TF_LOG=TRACE
#
terraform init
#
terraform workspace new lab-development
#terraform workspace new lab-production
#
