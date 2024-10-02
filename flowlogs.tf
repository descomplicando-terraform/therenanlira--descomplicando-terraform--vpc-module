# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "/aws/vpc/flow-logs"

  retention_in_days = 7
}

resource "aws_iam_role" "flow_logs_role" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.environment}--flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--flow-logs-role"
      Resource = "vpc.flow-logs-role"
    }
  )
}

resource "aws_iam_policy" "flow_logs_policy" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.environment}--flow-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          aws_cloudwatch_log_group.vpc_flow_logs[0].arn
        ]
      }
    ]
  })

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--flow-logs-policy"
      Resource = "vpc.flow-logs-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "flow_logs_role_policy_attachment" {
  count = var.enable_flow_logs ? 1 : 0

  role       = aws_iam_role.flow_logs_role[0].name
  policy_arn = aws_iam_policy.flow_logs_policy[0].arn
}

resource "aws_flow_log" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  iam_role_arn = aws_iam_role.flow_logs_role[0].arn
}
