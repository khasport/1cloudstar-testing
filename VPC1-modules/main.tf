resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "custom"
  }
}

# Create Security Group 

resource "aws_security_group" "vm1-sg" {
  name = "sec-grp"
  description = "Allow and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create VM-1 
resource "aws_instance" "vm-1" {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.vm1-sg.id]
}

#Create an Elastic IP
resource "aws_eip" "vm1-eip" {
  vpc = true
}

#Associate EIP with EC2 Instance
resource "aws_eip_association" "vm1-eip-association" {
  instance_id   = aws_instance.vm-1.id
  allocation_id = aws_eip.vm1-eip.id
}  


resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "custom"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "public"
  }
}