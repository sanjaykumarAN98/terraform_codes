resource "aws_vpc""vpc"{
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "word_vpc"
  }
}

#public subnet

resource "aws_subnet""public_subnet"{
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.pub
  availability_zone_id = "use1-az1"
  tags = {
    Name = "public_subnet"
  }

map_public_ip_on_launch = true
}

resource "aws_subnet""public_subnet1"{
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public1
  availability_zone_id = "use1-az2"
  tags = {
    Name = "public_subnet1"
  }

map_public_ip_on_launch = true
}


#private subnet

resource "aws_subnet""private_subnet"{

  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private
  availability_zone_id = "use1-az3"
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet""private_subnet1"{

  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private1
  availability_zone_id = "use1-az4"
  tags = {
    Name = "private_subnet1"
  }
}


#internet gateway

resource "aws_internet_gateway""mygateway"{

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

#route table with target as internet gateway

resource "aws_route_table""myroute"{

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.mygateway.id
  }

  tags = {
    Name = "route_table-01"
  }
}


#associate table to public subnet

resource "aws_route_table_association""rtassociation"{
  subnet_id = aws_subnet.public_subnet.id
 # subnet_id2 = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_route_table_association""rtassociation1"{
  # subnet_id = aws_subnet.public_subnet1.id
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.myroute.id
}


# elastic ip
resource "aws_eip" "elastic_ip" {
  vpc      = true
}

# NAT gateway
resource "aws_nat_gateway""nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# route table with target as NAT gateway
resource "aws_route_table" "NAT_route_table" {

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.all_cidr
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "NAT-route-table"
  }
}

# associate route table to private subnet
resource "aws_route_table_association" "associate_routetable_to_private_subnet" {

  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.NAT_route_table.id
}
