terraform {
  backend "s3" {
    bucket = "terraformoutputs"
    key    = "terraform-capstone.tfstate"
    region = "us-east-2"
  }
}
