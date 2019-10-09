variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "function_name" {
  type = string
}

variable "role" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

resource "aws_lambda_function" "terraformFunction" {
  s3_bucket = var.s3_bucket
  s3_key = var.s3_key
  function_name = var.function_name
  role = var.role
  handler = var.handler
  runtime = var.runtime
}
