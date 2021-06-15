variable "mytags" {
  type = list
  default = ["first", "second"]
}

resource "aws_instance" "apache-server" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = "mehmet"
  count = 2
  security_groups = ["xxxxxx ScGr name (aşşağıdaki) "]
  user_data = file("create_apache.sh")
  tags = {
      Name = "terraform ${element(var.mytags, count)} instance"
  }
  
  provisioner "remote-exac" {
    inline = [
        "sudo yum update -y",
        "sudo yum install -y yum-utils"
    ]
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/mehmet.pem (adresi gerçekle)")
    host = self.public_ip
}
}

}

data "aws_ami" "amazon-linux-2" { 
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"] 
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }


     
}


output "mypublic0" {
    value = "https://${aws.instance.apache-server[0].public_ip}"
  
}

output "mypublic1" {
    value = "https://${aws.instance.apache-server[1].public_ip}"
  
}

