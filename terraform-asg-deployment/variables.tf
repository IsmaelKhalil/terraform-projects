variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ik_subnet_cidr_block_1" {
  type    = string
  default = "172.31.101.0/24"
}

variable "ik_subnet_cidr_block_2" {
  type    = string
  default = "172.31.102.0/24"
}

variable "ik_subnet_az_1a" {
  type    = string
  default = "us-east-1a"
}

variable "ik_subnet_az_1b" {
  type    = string
  default = "us-east-1b"
}

variable "ik_sg_name" {
  type    = string
  default = "Terraform ASG Security Group"
}

variable "ik_vpc_id" {
  type    = string
  default = "vpc-0061fa15857aad1e0"
}

variable "ik_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ik_launch_template_name" {
  type    = string
  default = "LaunchTemplate-Terraform"
}

variable "ik_ami" {
  type    = string
  default = "ami-0427090fd1714168b"
}

variable "ik_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ik_s3_bucket_name" {
  type    = string
  default = "ikhalil-terraform-s3-bucket"
}