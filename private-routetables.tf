resource "aws_route_table" "private_internet_access" {
  count = var.azs_count

  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.single_nat_gateway ? [0] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
    }
  }

  dynamic "route" {
    for_each = var.single_nat_gateway ? [] : [0]
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
    }
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_only_internet_gateway.id
  }

  tags = {
    Name     = "${var.environment}--private-route-table--${data.aws_availability_zones.available.names[count.index]}"
    Resource = "vpc.private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = var.azs_count

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_internet_access[count.index].id
}
