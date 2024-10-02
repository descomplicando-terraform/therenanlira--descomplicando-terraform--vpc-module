resource "aws_egress_only_internet_gateway" "egress_only_internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--eigw"
      Resource = "vpc.eigw"
    }
  )
}
