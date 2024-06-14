# lab14
## Demonstrate a simple AWS lambda (python) which interacts w/RDS PostGreSQL, all deployed using Terraform.

Created 15 June, 2024 using Terrform 1.3.2

blah us-west-1


In lab13, terraform creates a VPC w/two public and two private subnets, a IGW, etc.  There is a bastion EC2 host which supports creation of database schema.  RDS (postgres) is in a private subnet and not readily accessible outside of VPC.  There is also a python lambda to demonstrate successful connection to RDS. 

Here are the steps necessary to recreate lab13 experiment

1. Clone from GitHub
    * Clone the postgres client libraries i.e. https://github.com/jkehler/awslambda-psycopg2.git (be sure to leave a star)
    * Clone my repository (you will need to tweak some files) i.e. git clone https://github.com/guycole/terraform-lab.git 
2. Update the terraform-lab repo for your environment
    * Within the "terraform-lab" repository, these instructions are exclusively about the directory "lab13"
    * Update the terraform backend references in main.tf 
    * Generate a keypair for EC2
    * Update the paths, etc in variables.tf
3. terraform apply
4. SSH to your fresh EC2 instance 
    * Verify connection to RDS, i.e. psql -h lab-db.coehbyjf9wsp.us-west-2.rds.amazonaws.com -p 5432 -d lab13 --user=usertest (your RDS hostname will be different, password is "bigsekret")
    * Create test schema by cut/pasting test_schema.sql into psql session.
5. Update lambda for your environment
    * Edit lambda/test_lambda.py to update RDS hostname
    * Update lambda/lambda_build.sh for correct awslambda-psycopg2 repo path
    * Invoke lambda/lambda_build.sh to create fresh lambda deployment zip
6. terraform apply to redploy lambda
7. Invoke the lambda (not matter how, web console is OK)
    * lambda execution should succeed
8. Proof of success is in cloudwatch which (should) contain the contents of the test1 table as "[(1, 2), (3, 4)]"