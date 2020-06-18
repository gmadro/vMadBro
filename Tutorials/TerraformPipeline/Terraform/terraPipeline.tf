provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

terraform {
    backend "s3" {
        bucket = "vmadbro-terraform-state"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-state"
    }
}

module "backend" {
  source = "./modules/terraPipeline"
}