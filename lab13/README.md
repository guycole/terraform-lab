# lab13
rds postgres w/python lambda

Create a VPC which contains a RDS PostGresSQL instance on private subnets, a EC2 bastion host and a Python lambda which is able to communicate w/the RDS instance.

Steps
1. Clone the postgres client libraries i.e. https://github.com/jkehler/awslambda-psycopg2.git (be sure to leave a star)
1. Clone my repository (you will need to tweak some files) i.e. git clone https://github.com/guycole/terraform-lab.git   
1. Within the "terraform-lab" repository, these instructions are exclusively about the directory "lab13"
1. Update the terraform backend references in main.tf 
1. Generate a keypair for EC2
1. Update the paths, etc in variables.tf
1. terraform apply
1. SSH to your fresh EC2 instance 
1. Verify connection to RDS, i.e. psql -h lab-db.coehbyjf9wsp.us-west-2.rds.amazonaws.com -p 5432 -d lab13 --user=usertest (your RDS hostname will be different, password is "bigsekret")
1. Create test schema by cut/pasting test_schema.sql into psql session.
1. Edit lambda/test_lambda.py to update RDS hostname
1. Update lambda/lambda_build.sh for correct awslambda-psycopg2 repo path
1. Invoke lambda/lambda_build.sh to create fresh lambda deployment zip
1. terraform apply to redploy lambda
1. invoke the lambda, not matter how, web console is OK
1. lambda execution should succeed
1. proof of success is in cloudwatch which contains the contents of the test1 table as "[(1, 2), (3, 4)]"