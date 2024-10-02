resource "aws_route_table" "public_internet_access" {
  count = var.azs_count

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_only_internet_gateway.id
  }

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--public-route-table--${data.aws_availability_zones.available.names[count.index]}"
      Resource = "vpc.public-route-table"
    }
  )
}

resource "aws_route_table_association" "public_subnet_association" {
  count = var.azs_count

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_internet_access[count.index].id
}
