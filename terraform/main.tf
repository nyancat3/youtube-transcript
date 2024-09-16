terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
  }

  required_version = ">= 1.2.0"
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "terraform_state_bucket" {
  type = string
}

variable "youtube_data_api_v3_key" {
  type = string
}

variable "youtube_playlist_id" {
  type = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_role" {
  name = "youtube_transcript_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "youtube_transcript_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/youtube-transcript:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "youtube-transcript"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  architectures    = ["arm64"]
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.lambda_policy_attachment]
  timeout          = 10
  environment {
    variables = {
      YOUTUBE_DATA_API_V3_KEY = var.youtube_data_api_v3_key,
      YOUTUBE_PLAYLIST_ID     = var.youtube_playlist_id
    }
  }
}
