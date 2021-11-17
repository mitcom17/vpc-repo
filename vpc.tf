# Create VPC
# terraform aws create vpc
resource "aws_vpc" "seunvpc" {
  cidr_block       = "${var.seunvpccidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "seun vpc"
  }
}

# Create Internet Gateway
# terraform aws create internet-gateway
resource "aws_internet_gateway" "seunigw" {
  vpc_id = aws_vpc.seunvpc.id

  tags = {
    Name = "seun internet gateway"
  }
}

# Allocate Elastic IP Address (EIP 1)
# terraform aws allocate elastic ip
resource "aws_eip" "seun-eip-for-nat-gateway-1" {
  vpc    = true

  tags   = {
    Name = "EIP1"
  }
}

# Allocate Elastic IP Address (EIP 2)
# terraform aws allocate elastic ip
resource "aws_eip" "seun-eip-for-nat-gateway-2" {
  vpc    = true

  tags   = {
    Name = "EIP2"
  }
}

# Create Nat Gateway 1 in Public Subnet 1
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.seun-eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.seun-public-subnet-1.id

  tags   = {
    Name = "seun nat gateway public subnet 1"
  }
}


# Create Nat Gateway 2 in Public Subnet 2
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.seun-eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.seun-public-subnet-2.id

  tags   = {
    Name = "seun nat gateway public subnet 2"
  }
}

# Create seun public subnet 1
# terraform aws create public-subnet
resource "aws_subnet" "seun-public-subnet-1" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-public-subnet1-cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "seun first public subnet"
  }
}

# Create seun public subnet 2
# terraform aws create public-subnet
resource "aws_subnet" "seun-public-subnet-2" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-public-subnet2-cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "seun second public subnet"
  }
}

# Create seun app subnet 1
# terraform aws create private-subnet 1
resource "aws_subnet" "seun-app-subnet-1" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-app-subnet1-cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "seun first app subnet"
  }
}

# Create seun app subnet 2
# terraform aws create private-subnet 2
resource "aws_subnet" "seun-app-subnet-2" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-app-subnet2-cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "seun second app subnet"
  }
}

# Create seun database subnet 1
# terraform aws create private-subnet 3
resource "aws_subnet" "seun-database-subnet-1" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-database-subnet1-cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "seun first database subnet"
  }
}

# Create seun database subnet 2
# terraform aws create private-subnet 4
resource "aws_subnet" "seun-database-subnet-2" {
  vpc_id     = aws_vpc.seunvpc.id
  cidr_block = "${var.seun-database-subnet2-cidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "seun second database subnet"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "seun-public-route-table" {
  vpc_id       = aws_vpc.seunvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.seunigw.id
  }

  tags       = {
    Name     = "seun public route table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.seun-public-subnet-1.id
  route_table_id      = aws_route_table.seun-public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.seun-public-subnet-2.id
  route_table_id      = aws_route_table.seun-public-route-table.id
}

# Create Private Route Table 1 and Add Route Through Nat Gateway 1
# terraform aws create route table
resource "aws_route_table" "seun-app-route-table" {
  vpc_id            = aws_vpc.seunvpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway-1.id
  }

  tags   = {
    Name = "seun private route table 1"
  }
}

# Associate App Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "seun-app-subnet-1-route-table-association" {
  subnet_id         = aws_subnet.seun-app-subnet-1.id
  route_table_id    = aws_route_table.seun-app-route-table.id
}

# Associate Databse Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "seun-database-subnet-1-route-table-association" {
  subnet_id         = aws_subnet.seun-database-subnet-1.id
  route_table_id    = aws_route_table.seun-app-route-table.id
}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
# terraform aws create route table
resource "aws_route_table" "seun-database-route-table" {
  vpc_id            = aws_vpc.seunvpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway-2.id
  }

  tags   = {
    Name = "seun private route table 2"
  }
}

# Associate App Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "seun-app-subnet-2-route-table-association" {
  subnet_id         = aws_subnet.seun-app-subnet-2.id
  route_table_id    = aws_route_table.seun-database-route-table.id
}

# Associate Database Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "seun-database-subnet-2-route-table-association" {
  subnet_id         = aws_subnet.seun-database-subnet-2.id
  route_table_id    = aws_route_table.seun-database-route-table.id
}