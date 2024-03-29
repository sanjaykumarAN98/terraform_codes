# Internet VPC
resource "aws_vpc" "cz" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
   tags = {
    Name = "cz"
  }
}

# Subnets
resource "aws_subnet" "cz-public-1" {
  vpc_id                  = aws_vpc.cz.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "cz-public-1"
  }
}

resource "aws_subnet" "cz-public-2" {
  vpc_id                  = aws_vpc.cz.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "cz-public-2"
  }
}



resource "aws_subnet" "cz-private-1" {
  vpc_id                  = aws_vpc.cz.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "cz-private-1"
  }
}

resource "aws_subnet" "cz-private-2" {
  vpc_id                  = aws_vpc.cz.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "cz-private-2"
  }
}



# Internet GW
resource "aws_internet_gateway" "cz-gw" {
  vpc_id = aws_vpc.cz.id

  tags = {
    Name = "cz"
  }
}

# route tables
resource "aws_route_table" "cz-public" {
  vpc_id = aws_vpc.cz.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cz-gw.id
  }

  tags = {
    Name = "cz-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "cz-public-1-a" {
  subnet_id      = aws_subnet.cz-public-1.id
  route_table_id = aws_route_table.cz-public.id
}

resource "aws_route_table_association" "cz-public-2-a" {
  subnet_id      = aws_subnet.cz-public-2.id
  route_table_id = aws_route_table.cz-public.id
}
