variable "flazouac" {
	description = "flazouac"
	default = "inconnu"
}

locals {
	address_spaces = {
		DEV = "10.0.10.0/24"
		PRD = "10.0.11.0/24"
	}
	address_space = local.address_spaces[terraform.workspace]
}

data "aws_availability_zones" "available" {
	state = "available"
}
