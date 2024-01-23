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

locals {
        vms = {
                DEV = {
                        "vm1" = {
                                disks = {
                                        "/dev/sdb" = 1
                                        "/dev/sdc" = 2
                                        }
                        }
                        "vm2" = {
                                disks = {
                                        "/dev/sdb" = 3
                                }
                        }
                }
                PRD = {
                        "vm" = {
                                disks = {
                                        "/dev/sdh" = 5
                                }
                        }
                }
        }
        vm = local.vms[terraform.workspace]
}

module "vm" {
  source      = "./modules/vm"
  for_each    = local.vm
  name        = upper(each.key)
  workspace   = terraform.workspace
  identifiant = var.identifiant
  az          = data.aws_availability_zones.available.names[0]
  subnet_id   = aws_subnet.this.id
  ami         = data.aws_ami.amazon-linux-2.id
  disks       = each.value.disks
}
