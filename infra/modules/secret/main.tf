resource "aws_kms_key" "sm_key" {
  description         = "KMS key for Secrets Manager"
  enable_key_rotation = true
}

resource "aws_secretsmanager_secret" "redshift_credentials" {
  name       = "${var.project_name}-redshift-credentials-v2-${random_id.suff.hex}"
  kms_key_id = aws_kms_key.sm_key.arn
}




resource "aws_secretsmanager_secret_version" "redshift_credentials_version" {
  secret_id = aws_secretsmanager_secret.redshift_credentials.id

  secret_string = jsonencode({
    username = var.redshift_master_username
    password = var.redshift_master_password
    db_name  = var.redshift_db
    host     = var.redshift_host
    port     = var.redshift_port
  })
}

resource "random_id" "suff" {
  byte_length = 2
}

#resource "random_password" "redshift" { length = 16 }


