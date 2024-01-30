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

resource "aws_security_group" "allow_5432" {
  name        = "allow_5432"
  description = "Allow 5432 inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "allow_5432"
  }
}

resource "aws_security_group_rule" "allow_rds_to_bastion" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.allow_5432.id
}

resource "aws_db_subnet_group" "database" {
  name       = "database"
  subnet_ids = [data.aws_subnet.private-a.id,data.aws_subnet.private-b.id]

  tags = {
    Name = "Groupe de sous-réseaux de Farid"
  }
}

 resource "aws_db_instance" "default" {
  allocated_storage    	= 10 
  db_name              	= "magasin"
  identifier	       	= "farid-magasin-db"
  license_model		= "postgresql-license"
  port 			= 5432
  availability_zone    	= "eu-west-3a"
  engine               	= "postgres"
  engine_version       	= "15"
  instance_class       	= "db.t3.micro"
  username             	= "postgres"
  password             	= "postgresroot"
  parameter_group_name 	= "default.postgres15"
  skip_final_snapshot  	= true
  vpc_security_group_ids = [aws_security_group.allow_5432.id]
  db_subnet_group_name	= aws_db_subnet_group.database.name
}
