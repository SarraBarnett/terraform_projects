# Create a resource block for ec2 instance
resource "aws_instance" "jenkins_server" {
  ami                    = "var.ami_id"
  instance_type          = "var.instance_type"
  vpc_security_group_ids = [aws_security_group.ec2_jenkins.id]
  user_data              = file("script.sh")
  key_name               = var.key_name
  tags = {
    Name = "var.instance_name"
  }
}

resource "aws_security_group" "ec2_jenkins" {
  name        = "ec2_jenkins"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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