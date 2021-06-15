# Please change the key_name and your config file 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.37.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

# Creating Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_Https_Http"
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
    protocol    = "-1"   #alll protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating fist Instance
resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = var.ec2-ami
  instance_type = var.ec2-type
  key_name = var.ec2-keyname
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
    Name = element(var.instance_tags, count.index)
  }
  #user_data = "${file("create_apache.sh")}"
  user_data = file("create_apache.sh")

  
  provisioner "local-exec" {
  command = "echo  ${element(var.instance_tags, count.index)} Public Ip is  ${self.public_ip} >> public_ip.txt "
  }
  provisioner "local-exec" {
  command = " echo ${element(var.instance_tags, count.index)} Ip is  ${self.private_ip} >> private_ip.txt"
  }
}



# Creating outputs
output "my-Instances-public-ips" {
  value = "${aws_instance.my-instance.*.public_ip}"
}