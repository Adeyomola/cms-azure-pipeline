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
      ]
    effect = "Allow"
    resources = [
"arn:aws:dynamodb:*:*:table/${var.table_name}",
    ]
    principals {
      type        = "AWS"
      identifiers = [var.arn]
    }
  }
}

resource "aws_iam_role" "ddb_role" {
  name        = "Dynamodb_Role"
  assume_role_policy = data.aws_iam_policy_document.ddb_policy.json
}
