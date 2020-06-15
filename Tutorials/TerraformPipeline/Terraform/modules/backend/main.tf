resource "aws_s3_bucket" "backend-s3" {
    bucket = "${var.app_name}-bucket"
    acl = "private"
}

resource "aws_dynamodb_table" "backend-dynamodb" {
    name = "${var.app_name}-table"
    billiob_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}