variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}


variable "project_name" {
  type    = string
  default = "adidas-fareye"
}





variable "lambda_s3_key_adidas" {
  type    = string
  default = "adidas-lambda.zip"
}


variable "lambda_s3_key_shopee" {
  type    = string
  default = "shopee-lambda.zip"
}


variable "lambda_s3_key_fareye" {
  type    = string
  default = "fareye-lambda.zip"
}


variable "vpc_enabled" {
  type    = bool
  default = false
}

variable "lambda_layer_s3_key_fpdf" {
  type    = string
  default = "fpdf-layer.zip"
}

variable "redshift_master_username" {
  description = "Username for Redshift master user"
  type        = string
  default     = "admin"
}

variable "redshift_master_password" {
  description = "Password for Redshift master user"
  type        = string
  sensitive   = true
  default     = "MustBeStrongP4ssword!" # Change this in production
}


variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
