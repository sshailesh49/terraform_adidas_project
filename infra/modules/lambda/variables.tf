variable "region" { type = string }


variable "project_name" { type = string }






variable "lambda_s3_key_adidas" { type = string }


variable "lambda_s3_key_shopee" { type = string }


variable "lambda_s3_key_fareye" { type = string }

variable "lambda_layer_s3_key_fpdf" { type = string }



variable "vpc_enabled" { type = bool }



variable "raw_bucket_id" {
  type = string
}

variable "pdf_bucket_id" {
  type = string
}



variable "sqs_url" {
  type = string
}

variable "redshift_workgroup_name" { type = string }
variable "redshift_secret_arn" { type = string }
variable "redshift_db" { type = string }


variable "main_queue_arn" { type = string }