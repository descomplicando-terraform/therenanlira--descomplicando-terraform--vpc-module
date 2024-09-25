output "id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnets_cidr_blocks" {
  value = aws_subnet.private_subnet[*].cidr_block
}

output "public_subnets_cidr_blocks" {
  value = aws_subnet.public_subnet[*].cidr_block
}

output "eip" {
  value = aws_eip.nat_eip[*].id
}