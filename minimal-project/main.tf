provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

}

data "local_file" "ssh-access-key" {
  filename = var.ssh-key
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key" # must match the filename!
  public_key = data.local_file.ssh-access-key.content
}

resource "aws_vpc" "sandbox" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags_all             = {
    Name = "sanbox_vpc"
  }
}

resource "aws_subnet" "sandbox_subnet" {
  cidr_block        = cidrsubnet(aws_vpc.sandbox.cidr_block, 3, 1)
  vpc_id            = aws_vpc.sandbox.id
  availability_zone = var.availability_zone
}

resource "aws_internet_gateway" "sandbox_gw" {
  vpc_id = aws_vpc.sandbox.id
}

resource "aws_route_table" "sandbox_route_table" {
  vpc_id = aws_vpc.sandbox.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sandbox_gw.id
  }
}

resource "aws_route_table_association" "sandbox_subnet_association" {
  subnet_id      = aws_subnet.sandbox_subnet.id
  route_table_id = aws_route_table.sandbox_route_table.id
}

resource "aws_security_group" "sandbox_sg" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.sandbox.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  key_name = aws_key_pair.ssh-key.key_name

  security_groups = ["${aws_security_group.sandbox_sg.id}"]
  subnet_id       = aws_subnet.sandbox_subnet.id
  tags            = {
    Name = "demo"
  }
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.demo.public_ip
}
