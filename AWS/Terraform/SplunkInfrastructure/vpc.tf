
# VPC Configuration
resource "aws_vpc" "splunkvpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = false
  tags = {
    Name = "splunkvpc"
  } 
}

# Subnet Configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.splunkvpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zones[0]

 tags = {
    Name = "splunk public Subnet"
  } 
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.splunkvpc.id
  cidr_block              = var.private_subnet_1_cidr_block
  availability_zone       = var.availability_zones[1]

  
  tags = {
    Name = "splunk Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.splunkvpc.id
  cidr_block              = var.private_subnet_2_cidr_block
  availability_zone       = var.availability_zones[2]

  tags = {
    Name = "splunk Private Subnet 2"
  }
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.splunkvpc.id
}

# Route Table Configuration
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.splunkvpc.id



  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Subnet Association Configuration
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.my_route_table.id
}


