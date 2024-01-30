locals {
        vms = {
                API = {
                        "vm1" = {
                                disks = {
                                        "/dev/sdb" = 1
                                        "/dev/sdc" = 2
                                        }
                        }
                }
             }
        vm = local.vms[terraform.workspace]
}
