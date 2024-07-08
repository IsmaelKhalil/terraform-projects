# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami           = "ami-06c68f701d8090592"
  instance_type = "t2.micro"
  key_name      = "IsmaelKhalil_UbuntuKey"
  user_data     = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    sudo dnf install java-17-amazon-corretto -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOF
  tags = {
    Name = "EC2 Server for Jenkins"
  }
  vpc_security_group_ids = [aws_security_group.sg_jenkins.id]
}

resource "aws_security_group" "sg_jenkins" {
  name        = "Security Group for Jenkins"
  vpc_id      = "vpc-0061fa15857aad1e0"
  description = "Web Traffic"

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "s3_jenkins" {
  bucket = "jenkins-s3-bucket-ikhalil"

  tags = {
    Name = "Jenkins Bucket"
  }
}