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

  ami                    = "ami-00c39f71452c08778"
  instance_type          = "t2.micro"


  tags = {
    Name = "jenkins_ec2_instance"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo 
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
EOF
}

resource "aws_security_group" "ec2_jenkins" {
  name        = "ec2_jenkins"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-03b53edf3579ce9c1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_s3_bucket" "jenkinsartifacts23" {
  bucket = "jenkinsartifacts23"

  tags = {
    Name        = "Jenkins Artifacts Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "privateJenkins_Artifactsbucket" {
  bucket = "jenkinsartifacts23"
  acl    = "private"
}
