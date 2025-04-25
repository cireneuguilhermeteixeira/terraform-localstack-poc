provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    dynamodb = "http://localhost:4566"
    iam      = "http://localhost:4566"
    sts      = "http://localhost:4566"
  }
}

# DynamoDB Table
resource "aws_dynamodb_table" "example_table" {
  name         = "MyTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Simulating Role
resource "aws_iam_role" "app_role" {
  name = "MinhaAppRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# DynamoDB Policy access 
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBAccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}