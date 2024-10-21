resource "aws_vpc" "main_vpc" {
  cidr_block                           = "172.32.0.0/24"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  instance_tenancy                     = "default"
  enable_network_address_usage_metrics = false
  tags = {
    Name = "main"
    Env  = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "172.32.0.0/26"
  availability_zone = "us-east-1d"
  tags = {
    Name = "Public"
    Env  = var.environment
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "172.32.0.128/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public"
    Env  = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "172.32.0.64/26"
  availability_zone = "us-east-1d"
  tags = {
    Name = "Private"
    Env  = var.environment
  }
}

resource "aws_internet_gateway" "main-internet-gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-internet-gateway"
    Env  = var.environment
  }
}

resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-internet-gateway.id
  }
  route {
    cidr_block = "172.32.0.0/24"
    gateway_id = "local"
  }
  tags = {
    Name = "main-route-table"
    Env  = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main-route-table.id
}

resource "aws_security_group" "main_instance_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "main_instance_sg"
  description = "main_instance_sg"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = false
  }
  tags = {
    Name = "main_instance_sg"
    Env  = var.environment
  }
}
