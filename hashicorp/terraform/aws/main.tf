provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

module "serverlessRoles" {
  source = "./modules/roles"

  app_name = var.app_name
}

module "serverlessTerraform" {
  source = "./modules/serverless-terraform"

  app_name      = var.app_name
  instance_type = "t2.micro"

  lambda_s3_key = "index.zip"
  lambda_role = module.serverlessRoles.role_arn
  lambda_handler = "index.main"
  lambda_runtime = "python3.7"
}
