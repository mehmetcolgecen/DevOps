variable "ec2-name-1" {
  default = "Terraform First Instance"
}
variable "ec2-name-2" {
  default = "Terraform Second Instance"
}

variable "instance_count" {
  default = "2"
}
variable "instance_tags" {
  type = list
  default = ["Terraform First Instance", "Terraform Second Instance"]
}



variable "ec2-type" {
  default = "t2.micro"
}
variable "ec2-keyname" {
  default = "bekir"
}

variable "ec2-ami" {
  default = "ami-0d5eff06f840b45e9"
}

variable "secgr-dynamic-ports" {
  default = [22,80,443]
}
