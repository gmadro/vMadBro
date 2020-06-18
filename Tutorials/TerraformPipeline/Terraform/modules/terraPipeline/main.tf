resource "aws_s3_bucket" "terrabucket" {
    bucket = "vmadbro-terrapipelinetest"
    acl = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.terrabucket.arn}",
                "${aws_s3_bucket.terrabucket.arn}/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
    name = "PipelineTest"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
    location = aws_s3_bucket.terrabucket.bucket
    type     = "S3"
    }

    stage {
        name = "Source"

        action {
            name = "Source"
            category = "Source"
            owner = "ThirdParty"
            provider = "GitHub"
            version = "1"
            output_artifacts = ["source_output"]

            configuration = {
                Owner = "gmadro"
                Repo = "terraRepo"
                Branch = "master"
            }
        }
    }

    stage {
        name = "Build"

        action {
            name = "Build"
            category = "Build"
            owner = "AWS"
            provider = "CodeBuild"
            version = "1"
            input_artifacts  = ["source_output"]

            configuration = {
                ProjectName = "TerraPipeline"
            }
        }
    }
}