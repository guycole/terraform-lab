# lab10 - Peered VPC

No modules, only resources

Two peered VPC (vpc1 10.100 and vpc2 10.200) 

Each VPC has two subnets and a security group that exposes port 80 to both VPC address range

Each subnet has an EC2 instance w/nginx 

From a peered VPC, I can visit each nginx instance using private VPC address (private IP)

SSH any instance from outside.
