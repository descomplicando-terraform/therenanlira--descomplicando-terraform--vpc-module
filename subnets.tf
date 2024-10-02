resource "aws_subnet" "private_subnet" {
  count = var.azs_count

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.vpc_private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--private-subnet--${data.aws_availability_zones.available.names[count.index]}"
      Resource = "vpc.private-subnet"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count = var.azs_count

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.vpc_public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--public-subnet--${data.aws_availability_zones.available.names[count.index]}"
      Resource = "vpc.public-subnet"
    }
  )
}