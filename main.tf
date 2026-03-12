provider "aws" {
  region = "us-east-1"
}

################################################
# S3 BUCKET
################################################

resource "aws_s3_bucket" "upload_bucket" {
  bucket = "afis-terraform-serverless-s3" 
  # CHANGE THIS
  # Bucket names must be globally unique
}
################################################ 
# DYNAMODB TABLE
################################################

resource "aws_dynamodb_table" "file_metadata_table" {
  name = "afis_terraform_file_metadata_table" 
  # CHANGE THIS if you want another name

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "file_id"

  attribute {
    name = "file_id"
    type = "S"
  }
}

################################################
# SNS TOPIC
################################################

resource "aws_sns_topic" "file_upload_topic" {
  name = "afis-terraform-file-upload-notification-topic"
  
}

################################################
# IAM ROLE FOR LAMBDA
################################################

resource "aws_iam_role" "lambda_role" {
  name = "lambda_file_processor_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

################################################
# IAM POLICY FOR LAMBDA PERMISSIONS
################################################

resource "aws_iam_role_policy" "lambda_policy" {

  name = "lambda_file_processor_policy"

  role = aws_iam_role.lambda_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = aws_dynamodb_table.file_metadata_table.arn
      },

      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.file_upload_topic.arn
      }

    ]
  })
}

################################################
# LAMBDA FUNCTION
################################################

resource "aws_lambda_function" "file_processor" {

  function_name = "file-processing-lambda"

  role    = aws_iam_role.lambda_role.arn
  runtime = "python3.12"
  handler = "handler.lambda_handler"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      TABLE_NAME     = aws_dynamodb_table.file_metadata_table.name
      SNS_TOPIC_ARN  = aws_sns_topic.file_upload_topic.arn
    }
  }
}

################################################
# S3 TRIGGER FOR LAMBDA
################################################

resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.file_processor.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.upload_bucket.arn
}

################################################
# S3 EVENT NOTIFICATION
################################################

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.file_processor.arn

    events = ["s3:ObjectCreated:*"]

  }

  depends_on = [aws_lambda_permission.allow_s3]
}