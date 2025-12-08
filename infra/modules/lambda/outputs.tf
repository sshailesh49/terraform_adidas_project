output "adidas_arn" {
  value = aws_lambda_function.adidas.arn
}

output "adidas_invoke_arn" {
  value = aws_lambda_function.adidas.invoke_arn
}

output "shopee_arn" {
  value = aws_lambda_function.shopee.arn
}

output "shopee_invoke_arn" {
  value = aws_lambda_function.shopee.invoke_arn
}

output "fareye_arn" {
  value = aws_lambda_function.fareye.arn
}

output "lambda_payload_bucket" {
  value = aws_s3_bucket.lambda_bucket.id
}
