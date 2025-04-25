provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    iam = "http://localhost:4566"
  }
}

resource "aws_iam_role" "db_access_role" {
  name = "local-db-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs.amazonaws.com"
      },
      Effect = "Allow",
    }]
  })
}

resource "aws_iam_policy" "db_policy" {
  name        = "db-policy"
  description = "Allow access to database"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds-db:connect"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "db_attach" {
  role       = aws_iam_role.db_access_role.name
  policy_arn = aws_iam_policy.db_policy.arn
}