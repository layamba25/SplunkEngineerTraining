
# Create a NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc" # Updated from deprecated 'vpc = true'
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "ct-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw,
    aws_subnet.public_subnet_1
  ]
}
