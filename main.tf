# Set a provider
provider "aws" {
  region = "eu-west-1"
}

# create vpc
resource "aws_vpc" "two-tier-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "two-tier-IG" {
  vpc_id = aws_vpc.two-tier-vpc.id

  tags = {
    Name = "${var.name} - IG"
  }
}

# Route table to allow internet comms
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.two-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.two-tier-IG.id
  }

  tags = {
  # this tag calls the variable and interpolates with the word route
    Name = "${var.name} - route"
  }
}

# Route table assocations - connecting public subnet with internet route
resource "aws_route_table_association" "public_route_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Create subnets
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.name} - public"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.two-tier-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.name} - private"
  }
}
# Route table to allow comms between subnets
resource "aws_route_table" "public_private_route" {
  vpc_id = aws_vpc.two-tier-vpc.id
  }
