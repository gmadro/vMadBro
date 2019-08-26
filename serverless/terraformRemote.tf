# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "vMadBro"
    token = "nx5cm0CoMu4acQ.atlasv1.NhFLh17z9pS3qHKVymaUHeg6oNdIC3sRh7tubRaxkU5onzoxHTyzghAmy5TdXWsfI9w"

    workspaces {
      name = "Test"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "example" {
  ami = "ami-0b898040803850657"
  instance_type = "t2.micro"
}
