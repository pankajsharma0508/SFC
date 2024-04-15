resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda"
  length = 3
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "calculator_lambda_role" {
  name               = "calculator_lambda"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "calculator_lambda_policy" {
  role       = aws_iam_role.calculator_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "calculator" {
  function_name    = "calculator"
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_calculator.key
  runtime          = "python3.11"
  handler          = "calculator.lambda_handler"
  source_code_hash = data.archive_file.lambda_calculator.output_base64sha256
  role             = aws_iam_role.calculator_lambda_role.arn
}

data "archive_file" "lambda_calculator" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_object" "lambda_calculator" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda.zip"
  source = data.archive_file.lambda_calculator.output_path
  etag   = filemd5(data.archive_file.lambda_calculator.output_path)
}
