provider "aws" {
  region = "us-east-1"
  shared_credentials_files = "$HOME/.aws/credentials"
}

resource "aws_lambda_function" "terraformFunction" {
  s3_bucket = "vmadbro-lambda-code"
  s3_key = "app_code_change.zip"
  function_name = "terraformFunction"
  role = "basic-lambda-role"
  handler = "index.main"
  runtime = "python3.7"
}
