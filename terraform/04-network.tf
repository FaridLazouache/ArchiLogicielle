
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

resource "aws_key_pair" "ec2" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKKzF6FhzbxCZ+u/DT21WVlev2e3ASRxWKI8bZ1TBYKxgJzxJGyjyvmphRcBc5fDZAcKfHdJH+hgd62PnW0se8O+M2zXmF5bkeCUcv8jBmW6wcXirtYzf2KoTqHJPMP5URu1AJlWc/+039w6Kdc8JleoDYFvMv7R8l72ctNHxubsb9mgcpuOa5g+n7QK8R1OCHyX7QlD5FBw4pmflq+BGs/Xu4h+KmRYVMnjwahE8vuWj+VOMSAPFZLZU9wk0YyrE86UK/6cksGrEK3a6eOqVo4dJI04JiUdPh172mfH4Bp7j6NAEdEmU9z5I+AXMlIfNfUPwuWVTawKjR61dx9XNR ec2-user@ip-10-0-1-91.eu-west-3.compute.internal"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-linux.id
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "${var.region}a"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2.id

  tags = { Name = upper("BASTION_EC2") }
}
