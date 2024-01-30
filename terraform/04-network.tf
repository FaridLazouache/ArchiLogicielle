resource "aws_vpc" "this" {
  cidr_block           = local.address_space
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_VPC") }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Default subnet for eu-west-3a"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-west-3b"

  tags = {
    Name = "Default subnet for eu-west-3b"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "eu-west-3c"

  tags = {
    Name = "Default subnet for eu-west-3c"
  }
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.address_space
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_SUBNET") }
}
 resource "aws_db_instance" "default" {
  allocated_storage    	= 10 
  db_name              	= "magasin"
  identifier	       	= "farid-magasin-db"
  license_model		= "postgresql-license"
  multi_az		= true
  port 			= 5432
  availability_zone    	= "eu-west-3a"
  engine               	= "postgres"
  engine_version       	= "15"
  instance_class       	= "db.t3.micro"
  username             	= "postgres"
  password             	= "postgresroot"
  parameter_group_name 	= "default.postgres15"
  skip_final_snapshot  	= true
}
