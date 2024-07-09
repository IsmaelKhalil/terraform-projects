variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ik_ami" {
  type    = string
  default = "ami-06c68f701d8090592"
}

variable "ik_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ik_key_name" {
  type    = string
  default = "IsmaelKhalil_UbuntuKey"
}

variable "ik_instance_tag_name" {
  type    = string
  default = "EC2 Server for Jenkins"
}

variable "ik_sg_name" {
  type    = string
  default = "Security Group for Jenkins"
}

variable "ik_vpc_id" {
  type    = string
  default = "vpc-0061fa15857aad1e0"
}

variable "ik_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ik_bucket" {
  type    = string
  default = "jenkins-s3-bucket-ikhalil"
}

variable "ik_bucket_tag_name" {
  type    = string
  default = "Jenkins Bucket"
}