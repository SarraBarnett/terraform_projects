variable "vpc_id" {
  type    = string
  default = "vpc-03b53edf3579ce9c1"
}

variable "ami_id" {
  type    = string
  default = "ami-0fa1de1d60de6a97e"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_cidr_block" {
  type    = string
  default = "172.31.0.0/16"
}

variable "subnet_cidr_block_1" {
  type    = string
  default = "172.31.0.0/20"
}

variable "subnet_cidr_block_2" {
  type    = string
  default = "172.31.80.0/20"
}

variable "subnet_id_1" {
  type    = string
  default = "subnet-05bb1af318d0fe1fc"
}

variable "subnet_id_2" {
  type    = string
  default = "subnet-06e5d3784f83cc3fd"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 5
}

variable "cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "launch_template_version" {
  type    = string
  default = "$Latest"
}