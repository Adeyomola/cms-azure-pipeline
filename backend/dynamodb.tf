resource "aws_dynamodb_table" "state_locking" {
  name           = var.table_name
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10
  attribute {
    name = "LockID"
    type = "S"
  }
}

data "aws_iam_policy_document" "ddb_policy" {
  statement {
    actions = [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
    Effect = "Allow",
    Resource = "arn:aws:dynamodb:*:*:table/${var.table_name}",
    principals {
      type        = "Service"
      identifiers = [aws_dynamodb_table.state_locking.id]
    }
  }
}

resource "aws_iam_role" "ddb_role" {
  name        = "Dynamodb_Role"
  assume_role_policy = data.aws_iam_policy_document.ddb_policy.json
}
