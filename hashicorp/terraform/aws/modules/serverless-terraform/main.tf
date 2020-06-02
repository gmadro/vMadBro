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

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "mod_bucket" {
  bucket = "${var.app_name}-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "mod_lambda_payload" {
    bucket = aws_s3_bucket.mod_bucket.id
    key = var.lambda_s3_key
    source = var.lambda_s3_key
}

resource "aws_lambda_function" "mod_lambda_function" {
    s3_bucket = aws_s3_bucket.mod_bucket.id
    s3_key = var.lambda_s3_key

    function_name = "${var.app_name}-function"
    role = var.lambda_role
    handler = var.lambda_handler
    runtime = var.lambda_runtime
}

resource "aws_instance" "mod_instance" {
  ami           = data.aws_ami.amz.id
  instance_type = var.instance_type

}

resource "aws_api_gateway_rest_api" "mod_api" {
    name = "${var.app_name}-api"
}

resource "aws_api_gateway_resource" "mod_api_resource" {
    rest_api_id = aws_api_gateway_rest_api.mod_api.id
    parent_id = aws_api_gateway_rest_api.mod_api.root_resource_id
    path_part = "${var.app_name}-function"
}

resource "aws_api_gateway_method" "mod_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.mod_api.id
  resource_id   = aws_api_gateway_resource.mod_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mod_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.mod_api.id
  resource_id             = aws_api_gateway_resource.mod_api_resource.id
  http_method             = aws_api_gateway_method.mod_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.mod_lambda_function.arn}/invocations"
}

resource "aws_lambda_permission" "mod_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mod_lambda_function.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.mod_api.id}/*/${aws_api_gateway_method.mod_api_method.http_method}${aws_api_gateway_resource.mod_api_resource.path}"
}

resource "aws_api_gateway_deployment" "mod_api_deploy" {
  depends_on = [aws_api_gateway_integration.mod_api_integration]

  rest_api_id = aws_api_gateway_rest_api.mod_api.id
  stage_name  = "prod"
}