# resource "aws_placement_group" "test" {
#   name     = "test"
#   strategy = "cluster"
# }

# resource "aws_autoscaling_group" "bar" {
#   name                      = "foobar3-terraform-test"
#   max_size                  = 5
#   min_size                  = 2
#   desired_capacity          = 2
#   force_delete              = true
#   placement_group           = aws_placement_group.test.id
#   launch_configuration      = aws_launch_configuration.foobar.name
#   vpc_zone_identifier       = [aws_subnet.example1.id, aws_subnet.example2.id]

#   instance_maintenance_policy {
#     min_healthy_percentage = 90
#     max_healthy_percentage = 120
#   }

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#     notification_metadata = jsonencode({
#       foo = "bar"
#     })

#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

#   tag {
#     key                 = "foo"
#     value               = "bar"
#     propagate_at_launch = true
#   }
# }

data "aws_vpc" "ik_default_vpc" {
  default = true
}

resource "aws_subnet" "ik_subnet_1" {
  vpc_id                  = data.aws_vpc.ik_default_vpc.id
  cidr_block              = var.ik_subnet_cidr_block_1
  availability_zone       = var.ik_subnet_az_1a
  map_public_ip_on_launch = true

  tags = {
    Name      = "Terraform Subnet 1"
    Terraform = "true"
  }
}

resource "aws_subnet" "ik_subnet_2" {
  vpc_id                  = data.aws_vpc.ik_default_vpc.id
  cidr_block              = var.ik_subnet_cidr_block_2
  availability_zone       = var.ik_subnet_az_1b
  map_public_ip_on_launch = true

  tags = {
    Name      = "Terraform Subnet 2"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "ik_internet_gateway" {
  vpc_id = data.aws_vpc.ik_default_vpc.id

  tags = {
    Name      = "Terraform Internet Gateway"
    Terraform = "true"
  }
}

resource "aws_route_table" "ik_route_table" {
  vpc_id = data.aws_vpc.ik_default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ik_internet_gateway.id
  }

  tags = {
    Name      = "Terraform Route Table"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "ik_rt_association_1" {
  subnet_id      = aws_subnet.ik_subnet_1.id
  route_table_id = aws_route_table.ik_route_table.id
}

resource "aws_route_table_association" "ik_rt_association_2" {
  subnet_id      = aws_subnet.ik_subnet_2.id
  route_table_id = aws_route_table.ik_route_table.id
}

resource "aws_security_group" "ik_sg_autoscaling" {
  name        = var.ik_sg_name
  vpc_id      = var.ik_vpc_id
  description = "Web Traffic"

  ingress {
    description = "Allow Port 80 for HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ik_cidr_block]
  }

  ingress {
    description = "Allow Port 443 for HTTPS"
    from_port   = 443
    to_port     = 443
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

resource "aws_launch_template" "ik_launch_template" {
  name                   = var.ik_launch_template_name
  image_id               = var.ik_ami
  instance_type          = var.ik_instance_type
  vpc_security_group_ids = [aws_security_group.ik_sg_autoscaling.id]
  user_data              = filebase64("asg_user_data.sh")
}

resource "aws_autoscaling_group" "ik_asg" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.ik_subnet_1.id, aws_subnet.ik_subnet_2.id]

  launch_template {
    id      = aws_launch_template.ik_launch_template.id
    version = "$Latest"
  }
}

data "aws_s3_bucket" "ik_s3_bucket" {
  bucket = var.ik_s3_bucket_name
}