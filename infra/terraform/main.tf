terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
    tls = {
        source = "hashicorp/tls"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "deployer" {
  key_name = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content = tls_private_key.ssh.private_key_openssh
  filename = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

resource "aws_security_group" "todo_ops" {
    name = "todo-ops-sg"
    description = "Allow SSH and app traffic"
  
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
     name = "name"
     values = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"
  }

  filter {
    name = "virtualization-type",
    values = ["hvm"]
  }
}

resource "aws_instance" "todo_ops" {
    ami = data.aws_ami.ubuntu
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.todo_ops.id]

    tags = {
        Name = "todo-ops-server"
    }
}