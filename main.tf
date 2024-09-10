# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test1" {
  ami	= "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  count	= 1
  tags  = {
  Name	= "Tf-Instance"
  }
}
