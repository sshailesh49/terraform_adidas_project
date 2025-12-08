resource "aws_sqs_queue" "dlq" {
  name = "${var.project_name}-dlq"
}
resource "aws_sqs_queue" "main" {
  name = "${var.project_name}-main-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}


