resource "aws_instance" "jenkins_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_jenkins.id]
  user_data              = file("script.sh")
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.s3_jenkins_instance_profile.name
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "ec2_jenkins" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_s3_bucket" "jenkinsartifacts23" {
  bucket = var.bucket_name
  tags = {
    Name        = "Jenkins Artifacts Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "privateJenkins_Artifactsbucket" {
  bucket = var.bucket_name
  acl    = var.s3_bucket_acl
}

# Create an AWS IAM Role and an assume role policy to allow
# the EC2 instance to assume this role

resource "aws_iam_role" "s3_jenkins_role" {
  name = "s3_jenkins_role"
  # "jsonencode" function converts HCL to JSON format
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_jenkins_role_policy" {
  policy_arn = "arn:aws:iam::061354871783:policy/s3_read_write_access"
  role       = aws_iam_role.s3_jenkins_role.name
  
  
}

resource "aws_iam_instance_profile" "s3_jenkins_instance_profile" {
  name = "s3_jenkins_instance_profile"
  role = aws_iam_role.s3_jenkins_role.name
}

# Make sure to add the iam_instance_profile attribute in the ec2 resource block