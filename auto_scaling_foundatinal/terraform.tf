terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-project"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}