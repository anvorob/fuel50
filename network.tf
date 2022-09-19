resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "VPC-${var.environment_name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-${var.environment_name}"
  }
}

# resource "aws_network_acl_rule" "deny_ssh" {
#   network_acl_id = aws_vpc.main.default_network_acl_id
#   rule_number    = 20
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "deny"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 22
#   to_port        = 22
# }

# resource "aws_network_acl_rule" "deny_rdp" {
#   network_acl_id = aws_vpc.main.default_network_acl_id
#   rule_number    = 21
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "deny"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 3389
#   to_port        = 3389
# }

// Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment_name}-cluster/InternetGateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Public Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment_name}-cluster/PublicRouteTable"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

  lifecycle {
    create_before_destroy = true
  }
}

// NAT IP
resource "aws_eip" "nat_ip" {
  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.environment_name}-cluster/NATIP"
  }

  lifecycle {
    create_before_destroy = true
  }
}