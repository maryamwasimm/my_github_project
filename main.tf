
provider "aws" {
  region = "us-east-1" 
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}


resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24" 

  tags = {
    Name = "MySubnet"
  }
}


resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

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

  tags = {
    Name = "MySecurityGroup"
  }
}


resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90" 
  instance_type = "t2.micro" 
  subnet_id     = aws_subnet.my_subnet.id

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyInstance"
  }
}

