# Define the VPC
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr_block
}

# Define the 2 subnets
resource "aws_subnet" "default_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.subnet_cidr_block_1
}

resource "aws_subnet" "default_subnet_2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.subnet_cidr_block_2
}

# Define the security group
resource "aws_security_group" "apache_sg" {
  name_prefix = "apache_sg"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }
}


# Define the launch template
resource "aws_launch_template" "apache" {
  name_prefix   = "apache"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = "${base64encode(file("apache.sh"))}"
}

# Define the auto scaling group
resource "aws_autoscaling_group" "apache-asg" {
  name_prefix        = "apache-asg"
  availability_zones = var.availability_zones
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size

  launch_template {
    id      = aws_launch_template.apache.id
    version = var.launch_template_version
  }
}

