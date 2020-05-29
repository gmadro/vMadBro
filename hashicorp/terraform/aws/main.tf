provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

data "aws_ami" "amz" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "test1" {
  ami           = data.aws_ami.amz.id
  instance_type = "t2.micro"

  tags = {
    Name = "terraTest"
  }
}

