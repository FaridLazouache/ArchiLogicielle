variable "identifiant" {
	description = "Votre ID"
	default = "flazouac"
}

locals {
	address_spaces = {
		API = "10.0.10.0/24"
	}
	address_space = local.address_spaces[terraform.workspace]
}
