resource "aws_sqs_queue" "dlq" {
  name                    = "${var.project_name}-dlq"
  sqs_managed_sse_enabled = true
}
resource "aws_sqs_queue" "main" {
  name                    = "${var.project_name}-main-queue"
  sqs_managed_sse_enabled = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}


