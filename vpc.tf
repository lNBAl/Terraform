resource "aws_vpc" "workshopvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "workshop vpc"
  }
}
#Creating Public Subnet
resource "aws_subnet" "wspublic" {
  vpc_id     = aws_vpc.workshopvpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = var.public_subnet_tags
  }
}
#Creating Private Subnet
resource "aws_subnet" "wsprivate" {
  vpc_id     = aws_vpc.workshopvpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_tags
  }
}
#Creating internet gateway
resource "aws_internet_gateway" "wsigw"{
  vpc_id = aws_vpc.workshopvpc.id

  tags = {
    Name = "workshop_igw"
  }
}
#Creating public rt
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.workshopvpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.wsigw.id
  }

  tags = {
    Name = "workshop_pub_rt"
  }
}
resource "aws_route_table_association" "wspublicassociation"{
  subnet_id      = aws_subnet.wspublic.id
  route_table_id = aws_route_table.public-rt.id
}
#Creating private rt
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.workshopvpc.id

  tags = {
    Name = "workshop_priv_rt"
  }
}
resource "aws_route_table_association" "wsprivateassociation"{
  subnet_id      = aws_subnet.wsprivate.id
  route_table_id = aws_route_table.private-rt.id
}
