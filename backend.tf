terraform {
  backend "s3" {
    bucket = "terraform.tfstate.yann"
    key    = "microservices-python-app.tfstate"
    region = "us-east-1"
  }
}