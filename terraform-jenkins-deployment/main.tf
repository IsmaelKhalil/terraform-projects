# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami           = var.ik_ami
  instance_type = var.ik_instance_type
  key_name      = var.ik_key_name
  user_data     = file("jenkins_user_data.sh")
  tags = {
    Name = var.ik_instance_tag_name
  }
  vpc_security_group_ids = [aws_security_group.sg_jenkins.id]
}

resource "aws_security_group" "sg_jenkins" {
  name        = var.ik_sg_name
  vpc_id      = var.ik_vpc_id
  description = "Web Traffic"

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ik_cidr_block]
  }

  ingress {
    description = "Allow Port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.ik_cidr_block]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ik_cidr_block]
  }
}

resource "aws_s3_bucket" "s3_jenkins" {
  bucket = var.ik_bucket

  tags = {
    Name = var.ik_bucket_tag_name
  }
}

resource "aws_s3_bucket_public_access_block" "s3_jenkins_block" {
  bucket = aws_s3_bucket.s3_jenkins.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}