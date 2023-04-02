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
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"

  tags = {
    Name = terraformProject
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