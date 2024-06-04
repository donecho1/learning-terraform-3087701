data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}
data "aws_vpc" "default"{
default =true
}

resource "aws_instance" "blog" {

  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = "Learning Terraform"
  }
}

resource "aws_security_group" "blog"{
name        = "blog"
description ="Allow http and https in. Allow everything out"

vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "blog_https_in" {
  type       = "ingress"
  from-port  = 443
  to_port    = 443
  protocal   = "tcp"
  cidr_block = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group" "blog_everything_out" {
  type       = "egress"
  from-port  = 0
  to_port    = 0
  protocal   = "-1"
  cidr_block = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id
}
