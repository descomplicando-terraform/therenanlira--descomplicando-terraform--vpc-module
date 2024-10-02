resource "aws_eip" "nat_eip" {
  count = var.single_nat_gateway ? 1 : var.azs_count

  domain = "vpc"

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--eip--${data.aws_availability_zones.available.names[count.index]}"
      Resource = "vpc.eip"
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.single_nat_gateway ? 1 : var.azs_count

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--ngw--${data.aws_availability_zones.available.names[count.index]}"
      Resource = "vpc.ngw"
    }
  )
}
