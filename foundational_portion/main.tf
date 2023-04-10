# Configure aws provider version

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61.0"
    }
  }
}

# Configure the aws provider and region

provider "aws" {
  region = "us-east-1"
}

# Create a resource block for ec2 instance

resource "aws_instance" "jenkins_server" {

  ami                    = "ami-0fa1de1d60de6a97e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = "projectkeypair"
  user_data              = file("jenkins.sh")


  tags = {
    Name = "jenkins_ec2_instance"
  }
}

# Create and assign a Security Group to the Jenkins EC2 that allows traffic on 
# port 22 and 8080

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-03b53edf3579ce9c1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a S3 bucket for your Jenkins Artifacts that is not open to the public

resource "aws_s3_bucket" "jenkinsartifacts23" {
  bucket = "jenkinsartifacts23"
  tags = {
    Name        = "Jenkins Artifacts Bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_acl" "jenkinsartifacts23_private" {
  bucket = aws_s3_bucket.jenkinsartifacts23.id
  acl    = "private"
}

