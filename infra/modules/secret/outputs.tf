output "redshift_secret_arn" {
  value = aws_secretsmanager_secret.redshift_credentials.arn
}

output "redshift_secret_name" {
  value = aws_secretsmanager_secret.redshift_credentials.name
}

output "redshift_secret_value" {
  value     = var.redshift_master_password
  sensitive = true
}