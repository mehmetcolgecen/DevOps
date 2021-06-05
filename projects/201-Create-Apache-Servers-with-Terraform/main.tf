terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.38.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

variable "secgr-dynamic-ports" {
  default = [22,80,443]
}

variable "instance_count" {
  default = "2"
}

variable "instance-type" {
  default = "t2.micro"
  sensitive = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
    for_each = var.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf-ec2" {
  count = var.instance_count
  ami           = "ami-0d5eff06f840b45e9"
  instance_type = var.instance-type
  key_name = "mehmet"
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  iam_instance_profile = "terraform"
      tags = {
      Name = "apache-sever-${count.index + 1}"
  }

  user_data = file("create_apache.sh")

provisioner "local-exec" {
  command = "echo apache sever ${count.index + 1} public ip is ${self.public_ip} >> public.txt"
  }

provisioner "local-exec" {
  command = "echo apache sever ${count.index + 1} private ip is ${self.private_ip} >> private.txt"
  }
}

output "myec2-public-ip" {
  value = aws_instance.tf-ec2.*.public_ip
#  sensitive = true
}