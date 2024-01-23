resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 10

  tags = { Name = upper("${var.flazouac}_${terraform.workspace}_EBS_VOLUME") }
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

resource "aws_instance" "vm" {
  ami               = data.aws_ami.amazon-linux-2.id
  subnet_id         = aws_subnet.this.id
  availability_zone = data.aws_availability_zones.available.names[0]
  instance_type     = "t2.micro"

  tags = { Name = upper("${var.flazouac}_${terraform.workspace}_VM") }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.vm.id
}
