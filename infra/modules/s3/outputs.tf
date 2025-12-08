output "raw_bucket" {
  value = aws_s3_bucket.raw.id
}

output "pdf_bucket" {
  value = aws_s3_bucket.pdf.id
}
