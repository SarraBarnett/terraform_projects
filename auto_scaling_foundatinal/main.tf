# Configuring the security group
resource "aws_security_group" "apache_sg" {
  name_prefix = "apache_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }
}

# Selecting two subnets from my default vpc
data "aws_subnets" "selected_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "subnet-id"
    values = [var.subnet_id_1, var.subnet_id_2]
  }
}

# Configuring the launch template
resource "aws_launch_template" "apache" {
  name_prefix   = "apache"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("apache.sh"))
}

# Configuring the auto scaling group
resource "aws_autoscaling_group" "apache-asg" {
  name_prefix         = "apache-asg"
  vpc_zone_identifier = data.aws_subnets.selected_subnets.ids
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size

  launch_template {
    id      = aws_launch_template.apache.id
    version = var.launch_template_version
  }
}