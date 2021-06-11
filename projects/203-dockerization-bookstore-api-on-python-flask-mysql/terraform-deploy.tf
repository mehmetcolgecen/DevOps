//This Terraform Template creates a Docker machine on EC2 Instance and
//deploys Bookstore Web API, Docker Machine will run on Amazon Linux 2
//EC2 Instance with custom security group allowing HTTP (Port 80)
//and SSH (Port 22) connections from anywhere.

provider "aws" {
  region = "us-east-1"
  //  access_key = ""
  //  secret_key = ""
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

resource "aws_instance" "tf-docker-ec2" {
  ami             = "ami-09d95fab7fff3776c"
  instance_type   = "t2.micro"
  key_name        = "mehmet"
  //  Write your pem file name
  security_groups = ["docker-sec-gr-202"]
  tags = {
    Name = "Bookstore-Web-Server"
  }
  user_data = file("build-deploy.sh")
}

resource "aws_security_group" "tf-docker-sec-gr-202" {
  name = "docker-sec-gr-202"
  tags = {
    Name = "docker-sec-group-202"
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