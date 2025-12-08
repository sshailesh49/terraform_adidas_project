data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create IAM role and lambda functions
resource "aws_iam_role" "lambda_exec" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}


resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-inline"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"sqs:SendMessage",
				"sqs:ReceiveMessage",
				"sqs:DeleteMessage",
				"sqs:GetQueueAttributes"
			],
			"Resource": "arn:aws:sqs:ap-south-1:750784683061:adidas-fareye-main-queue"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject"
			],
			"Resource": [
				"arn:aws:s3:::adidas-fareye-raw-be4c/*",
				"arn:aws:s3:::adidas-fareye-pdf-be4c/*"
			]
		},
		{
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": [
				"arn:aws:s3:::adidas-fareye-raw-be4c",
				"arn:aws:s3:::adidas-fareye-pdf-be4c"
			]
		},
		{
			"Effect": "Allow",
			"Action": "secretsmanager:GetSecretValue",
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"redshift-data:ExecuteStatement",
				"redshift-data:GetStatementResult",
				"redshift-data:DescribeStatement"
			],
			"Resource": "*"
		}
	]
})
}



# --------------------------------------------------------------------------------
# Fareye Lambda Role & Permissions
# --------------------------------------------------------------------------------

resource "aws_iam_role" "fareye_exec" {
  name               = "${var.project_name}-fareye-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "fareye_basic_exec" {
  role       = aws_iam_role.fareye_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "fareye_policy" {
  name = "${var.project_name}-fareye-inline"
  role = aws_iam_role.fareye_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "redshift:*",
          "redshift-data:*",
          "secretsmanager:*",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage",
          "kms:Decrypt",
				  "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}
