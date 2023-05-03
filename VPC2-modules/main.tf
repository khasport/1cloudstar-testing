resource "aws_vpc" "vpc02" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "custom"
  }
}

# Create Security Group 

resource "aws_security_group" "vm2-sg" {
  name = "sec-grp"
  description = "Allow and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.101.0/28","192.168.100.0/28"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create VM-2 
resource "aws_instance" "vm-2" {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t3.medium"
  vpc_security_group_ids = [aws_security_group.vm2-sg.id]
}


resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    "Name" = "private-subnet"
  }
}

