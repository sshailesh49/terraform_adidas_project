
resource "aws_s3_bucket" "raw" {
  bucket        = "${var.project_name}-raw-${random_id.suffix.hex}"
  force_destroy = true
}
resource "aws_s3_bucket" "pdf" {
  bucket        = "${var.project_name}-pdf-${random_id.suffix.hex}"
  force_destroy = true
}


resource "random_id" "suffix" {
  byte_length = 2
}


