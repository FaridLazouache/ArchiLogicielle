
resource "aws_security_group" "rds" {
  name        = "${var.identifiant}_SG_RDS"
  description = "Allow 5432 inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "${var.identifiant}_SG_RDS"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_rds_to_bastion" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group" "api" {
  name        = "${var.identifiant}_SG_API"
  description = "Manage API Traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "${var.identifiant}_SG_API"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "in_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_security_group_rule" "out_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_security_group_rule" "in_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_security_group_rule" "out_80" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_security_group_rule" "in_5964" {
  type                     = "ingress"
  from_port                = 5964
  to_port                  = 5964
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_security_group_rule" "out_5964" {
  type                     = "egress"
  from_port                = 5964
  to_port                  = 5964
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion.id
  security_group_id        = aws_security_group.api.id
}

resource "aws_db_subnet_group" "database" {
  name       = "${var.identifiant}_database"
  subnet_ids = [data.aws_subnet.private-a.id,data.aws_subnet.private-b.id]

  tags = {
    Name = "Groupe de sous-réseaux de Farid"
  }
}

 resource "aws_db_instance" "default" {
  allocated_storage    	= 10 
  db_name              	= "magasin"
  identifier	       	= "${var.identifiant}-magasin-db"
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
  vpc_security_group_ids = [aws_security_group.rds.id, aws_security_group.api.id]
  db_subnet_group_name	= aws_db_subnet_group.database.name
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2-key-${var.identifiant}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuM88UAcSO5cVrJLYeHC0y2JaasNb6zEwcH1eMnVFBhjGf5LZ/D8HU6MjhWgnMoV9o2OIQV1adQqU+gtgFPm+KVQSOe59+y9u4IVpq/wfjBwLQ/waa8uELDoD/gFU2TzPudMNwawd6HnrwzuP3iqL06WV43Fg+EIlJcgIyh955xQAUmgYlSU7rZXywY15EAM7Wg/K4652SFewBlAs407fbY/jnt79+gVLCPLMaPoeQ2el2YfHZ/qe6maGb5kHTAQmBpmSz93q2TLMxzz6ZWPJSBhmtYVpJWWE6fxP/Y66ugDl/USaT6xdh2bINkZGGfElB2Tz0AtiQ8sFVJRFvhoGT ec2-user@ip-10-0-1-91.eu-west-3.compute.internal"
}

resource "aws_instance" "farid_api" {
  ami                         = data.aws_ami.amazon-linux-2.id
  subnet_id                   = data.aws_subnet.private-a.id 
  availability_zone           = "${var.region}a"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [data.aws_security_group.bastion.id]
  key_name                    = aws_key_pair.ec2.id

  tags = { Name = upper("${var.identifiant}_API") }
}
