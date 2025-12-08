resource "aws_secretsmanager_secret" "redshift_credentials" {
  name = "${var.project_name}-redshift-credentials-v2"
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



#resource "random_password" "redshift" { length = 16 }


