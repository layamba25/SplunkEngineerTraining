terraform {
  backend "s3" {
    bucket = "terraformoutputs-awx"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}