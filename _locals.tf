locals {
  vpc_private_cidr_blocks = [for i in range(var.azs_count) : cidrsubnet(var.vpc_cidr_block, 4, i)]
  vpc_public_cidr_blocks  = [for i in range(var.azs_count) : cidrsubnet(var.vpc_cidr_block, 4, i + var.azs_count)]
}
