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

resource "aws_s3_bucket" "mod_bucket" {
  bucket = "${var.app_name}-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "lambda_payload" {
    bucket = aws_s3_bucket.mod_bucket.id
    key = var.lambda_s3_key
    source = var.lambda_s3_key
}

resource "aws_lambda_function" "lambda_function" {
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

  tags = {
    Name = "${var.app_name}-instance"
  }
}

