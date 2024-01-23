resource "aws_ebs_volume" "ebs_volume" {
  for_each = var.disks
  availability_zone = var.az
  size              = each.value

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_EBS_VOLUME") }
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
  ami               = var.ami 
  subnet_id         = var.subnet_id
  availability_zone = var.az
  instance_type     = "t2.micro"

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_VM") }
}

resource "aws_volume_attachment" "ebs_att" {
  for_each = var.disks
  device_name = each.key
  volume_id   = aws_ebs_volume.ebs_volume[each.key].id
  instance_id = aws_instance.vm.id
}
