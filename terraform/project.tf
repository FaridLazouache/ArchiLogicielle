data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["PUBLIC_SUBNET"]
  }
}

data "aws_subnet" "private-a" {
  filter {
    name   = "tag:Name"
    values = ["PRIVATE_SUBNET_A"]
  }
}

data "aws_subnet" "private-b" {
  filter {
    name   = "tag:Name"
    values = ["PRIVATE_SUBNET_B"]
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["VPC"]
  }
}

data "aws_security_group" "bastion" {
  filter {
    name   = "tag:Name"
    values = ["SG_BASTION_EC2"]
  }
}
