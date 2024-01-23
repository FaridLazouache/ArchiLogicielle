resource "aws_vpc" "this" {
  cidr_block           = local.address_space
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_VPC") }
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.address_space
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = { Name = upper("${var.identifiant}_${terraform.workspace}_SUBNET") }
}
