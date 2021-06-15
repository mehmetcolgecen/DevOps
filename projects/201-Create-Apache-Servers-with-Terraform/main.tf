terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
<<<<<<< HEAD
<<<<<<< HEAD
      version = "3.42.0"
=======
      version = "3.38.0"
>>>>>>> 52c97c4e33de0c84d6322f78c932ceafcd7b54a5
=======
      version = "3.42.0"
>>>>>>> e4d47162a527adb7bbb6d4e17844506122c3a21d
    }
  }
}

provider "aws" {
  region  = "us-east-1"
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e4d47162a527adb7bbb6d4e17844506122c3a21d
#   profile = "cw-training"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "apache-server" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
//  key_name        = "northvirginia"
  count           = 2
  security_groups = ["tf-project"]
  user_data = file("create_apache.sh")

  tags = {
    Name = "terraform ${element(var.mytags, count.index)} instance"
  }
    provisioner "local-exec" {
      command = "echo ${self.private_ip} >> private_ip.txt"
    }
    provisioner "local-exec" {
      command = "echo ${self.public_ip} >> public_ip.txt"
    }
}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-project"

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
variable "mytags" {
  type    = list(string)
  default = ["first", "second"]
}

output "mypublicip" {
  value = aws_instance.apache-server[*].public_ip
<<<<<<< HEAD
=======
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
>>>>>>> 52c97c4e33de0c84d6322f78c932ceafcd7b54a5
=======
>>>>>>> e4d47162a527adb7bbb6d4e17844506122c3a21d
}