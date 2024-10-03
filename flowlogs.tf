# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "/aws/vpc/flow-logs"

  retention_in_days = var.flow_logs_retention_in_days
}

data "aws_iam_policy_document" "flow_logs_assume_role_policy" {
  count = var.enable_flow_logs ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flow_logs_role" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.environment}--flow-logs-role"

  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role_policy[count.index].json

  tags = merge(
    var.default_tags,
    {
      Name     = "${var.environment}--flow-logs-role"
      Resource = "vpc.flow-logs-role"
    }
  )
}

data "aws_iam_policy_document" "flow_logs_policy" {
  count = var.enable_flow_logs ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.vpc_flow_logs[0].arn
    ]
  }
}

resource "aws_iam_policy" "flow_logs_policy" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.environment}--flow-logs-policy"

  policy = data.aws_iam_policy_document.flow_logs_policy[count.index].json

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
