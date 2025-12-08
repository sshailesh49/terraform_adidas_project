# ------------------------
# 1 Create S3 bucket ----
# ------------------------
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "${var.project_name}-lambda-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_pab" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_encryption" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------
# 2. Create ZIP file of Lambda from ./lambda
# ------------------------
data "archive_file" "adidas_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../lambdas/adidas-lambda"
  output_path = "${path.root}/../lambdas/adidas-lambda.zip"
}



# ------------------------
# 3 Upload ZIP file to S31
# ------------------------
resource "aws_s3_object" "adidas_zip_upload" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = var.lambda_s3_key_adidas
  source = data.archive_file.adidas_zip.output_path
  etag   = filemd5(data.archive_file.adidas_zip.output_path)
}

# ------------------------
# FPDF Layer Zip
# ------------------------
data "archive_file" "fpdf_layer_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../lambdas/fpdf-layer"
  output_path = "${path.root}/../lambdas/fpdf-layer.zip"
}

resource "aws_s3_object" "fpdf_layer_upload" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "layers/fpdf-layer.zip"
  source = data.archive_file.fpdf_layer_zip.output_path
  etag   = filemd5(data.archive_file.fpdf_layer_zip.output_path)
}


resource "aws_lambda_layer_version" "fpdf_layer" {
  layer_name          = "fpdf_layer_IsThisReal"
  s3_bucket           = aws_s3_bucket.lambda_bucket.bucket
  s3_key              = var.lambda_layer_s3_key_fpdf
  compatible_runtimes = ["python3.11"]
}



resource "aws_lambda_function" "adidas" {
  function_name = "AdidasLambda"
  #s3_bucket = var.s3_bucket
  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = var.lambda_s3_key_adidas
  handler   = "handler.lambda_handler"
  runtime   = "python3.11"
  role      = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      RAW_BUCKET = var.raw_bucket_id
      PDF_BUCKET = var.pdf_bucket_id
      SQS_URL    = var.sqs_url
    }
  }
  tracing_config {
    mode = "Active"
  }
  layers = [aws_lambda_layer_version.fpdf_layer.arn]
}


# ------------------------
# 2 Create ZIP file of Lambda from ./lambda
# ------------------------
data "archive_file" "shopee_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../lambdas/shopee-lambda"
  output_path = "${path.root}/../lambdas/shopee-lambda.zip"
}



# ------------------------
# 3 Upload ZIP file to S3
# ------------------------
resource "aws_s3_object" "shopee_zip_upload" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = var.lambda_s3_key_shopee
  source = data.archive_file.shopee_zip.output_path
  etag   = filemd5(data.archive_file.shopee_zip.output_path)
}


resource "aws_lambda_function" "shopee" {
  function_name = "ShopeeLambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = var.lambda_s3_key_shopee
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = {
      RAW_BUCKET = var.raw_bucket_id
      PDF_BUCKET = var.pdf_bucket_id
      SQS_URL    = var.sqs_url
    }
  }
}

# ------------------------
# 2 Create ZIP file of Lambda from ./lambda
# ------------------------
data "archive_file" "fareye_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../lambdas/fareye-lambda"
  output_path = "${path.root}/../lambdas/fareye-lambda.zip"
}



# ------------------------
# 3 Upload ZIP file to S3
# ------------------------
resource "aws_s3_object" "fareye_zip_upload" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = var.lambda_s3_key_fareye
  source = data.archive_file.fareye_zip.output_path
  etag   = filemd5(data.archive_file.fareye_zip.output_path)
}

resource "aws_lambda_function" "fareye" {
  function_name = "FarEyeLambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = var.lambda_s3_key_fareye
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.fareye_exec.arn
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = {
      REDSHIFT_WORKGROUP  = var.redshift_workgroup_name
      REDSHIFT_SECRET_ARN = var.redshift_secret_arn
      REDSHIFT_DB         = var.redshift_db

    }
  }

}


