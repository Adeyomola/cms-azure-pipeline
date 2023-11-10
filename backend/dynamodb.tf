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

data "aws_iam_policy_document" "ddb_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = [aws_dynamodb_table.state_locking.id]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "ddb_role" {
  name        = "Dynamodb_Role"
  assume_role_policy = data.aws_iam_policy_document.ddb_role.json
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
  }
}

resource "aws_iam_policy" "ddb_policy" {
  name        = "DDB-policy"
  policy      = data.aws_iam_policy_document.ddb_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ddb_role.name
  policy_arn = aws_iam_policy.ddb_policy.arn
}