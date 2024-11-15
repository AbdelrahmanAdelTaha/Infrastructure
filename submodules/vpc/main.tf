# vpc

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}"
    Environment = var.environment
  }
}

# internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}"
    Environment = var.environment
  }
}

# nat gateway

resource "aws_nat_gateway" "main" {
  lifecycle {
    prevent_destroy = true
  }
  count         = length(var.private_nat_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# nat ips

resource "aws_eip" "nat" {
  count = length(var.private_nat_subnets)
  vpc   = true
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# private nat subnets

resource "aws_subnet" "private_nat" {
  count                   = length(var.private_nat_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_nat_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}-private-nat-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# private subnets

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}-private-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# public subnets

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}-public-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.module}-${var.environment}"
    Environment = var.environment
  }
}

# public route

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# private nat route table

resource "aws_route_table" "private_nat" {
  count  = length(var.private_nat_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.module}-private-nat-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# private route table

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.module}-private-${format("%03d", count.index + 1)}"
    Environment = var.environment
  }
}

# private nat route

resource "aws_route" "private_nat" {
  count                  = length(compact(var.private_nat_subnets))
  route_table_id         = element(aws_route_table.private_nat.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

# private nat route table association

resource "aws_route_table_association" "private_nat" {
  count          = length(var.private_nat_subnets)
  subnet_id      = element(aws_subnet.private_nat.*.id, count.index)
  route_table_id = element(aws_route_table.private_nat.*.id, count.index)
}

# private route table association

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# public route table association

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# flow grafana

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

# cloudwatch

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.project_name}-${var.module}-${var.submodule}-${var.environment}"
  tags = {
    Name = "${var.project_name}-${var.module}-${var.submodule}-${var.environment}"
  }
}

# role for cloudwatch logs

resource "aws_iam_role" "vpc-flow-logs-role" {
  name               = "${var.project_name}-${var.module}-${var.submodule}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_access_role.json
}

data "aws_iam_policy_document" "vpc_flow_logs_access_role" {
  statement {
    sid     = "${var.project_name}0${var.module}0${var.submodule}0${var.environment}"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# policy for cloudwatch logs

resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name   = "${var.project_name}-${var.module}-${var.submodule}-${var.environment}"
  role   = aws_iam_role.vpc-flow-logs-role.id
  policy = data.aws_iam_policy_document.vpc_flow_logs_access_policy.json
}

data "aws_iam_policy_document" "vpc_flow_logs_access_policy" {
  statement {
    sid    = "${var.project_name}0${var.module}0${var.submodule}0${var.environment}"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}