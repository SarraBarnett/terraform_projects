variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  default     = "ami-0fa1de1d60de6a97e"
}

variable "instance_type" {
  description = "The instance type for the instances"
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
  default = "172.31.0.0/16"
}

variable "subnet_cidr_block_1" {
  default = "172.31.0.0/20"
}

variable "subnet_cidr_block_2" {
  default = "172.31.80.0/20"
}

variable "desired_capacity" {
  default = 2
}


variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 5
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "cidr_block" {
  default = ["0.0.0.0/0"]
}

variable "launch_template_version" {
  default = "$Latest"
}