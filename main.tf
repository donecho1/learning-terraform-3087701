# First module definition (unchanged)
module "security-group_1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# Second module definition with a new name
module "security-group_2" { # Changed the name here
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"
  name    = "blog_new"

  vpc_id = module.security-group_1.vpc_id # Note: You might need to adjust this if the VPC ID is expected to come from the renamed module

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks =["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks =["0.0.0.0/0"]
}

# Adjusted resource block to use the new module name
resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [module.security-group_2.security_group_id] # Updated to match the new module name

  subnet_id = module.security-group_1.public_subnets[0] # Assuming you want to keep using the first public subnet from the original module

  tags = {
    Name = "Learning Terraform"
  }
}
