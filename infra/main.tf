module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}


module "sqs" {
  source       = "./modules/sqs"
  project_name = var.project_name
}


module "secrets" {
  source        = "./modules/secret"
  project_name  = var.project_name
  redshift_host = module.redshift.workgroup_endpoint
  redshift_port = module.redshift.workgroup_port
  redshift_db   = module.redshift.database_name
}

module "lambda" {
  source = "./modules/lambda"

  region       = var.region
  project_name = var.project_name


  lambda_s3_key_adidas = var.lambda_s3_key_adidas
  lambda_s3_key_shopee = var.lambda_s3_key_shopee
  lambda_s3_key_fareye = var.lambda_s3_key_fareye



  vpc_enabled = var.vpc_enabled

  raw_bucket_id = module.s3.raw_bucket
  pdf_bucket_id = module.s3.pdf_bucket


  sqs_url = module.sqs.queue_url

  # NEW: Redshift inputs
  # NEW: Redshift inputs
  redshift_workgroup_name = module.redshift.workgroup_name
  redshift_secret_arn     = module.secrets.redshift_secret_arn
  redshift_db             = module.redshift.database_name

  # Merge base ENV + auto values  -  -


  #env                  = var.env


}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = module.sqs.queue_arn
  function_name    = module.lambda.fareye_arn
  enabled          = true
  batch_size       = 10
}


module "apigw" {
  source               = "./modules/apigw"
  project_name         = var.project_name
  adidas_invoke_arn    = module.lambda.adidas_invoke_arn
  adidas_function_name = module.lambda.adidas_arn
  shopee_invoke_arn    = module.lambda.shopee_invoke_arn
  shopee_function_name = module.lambda.shopee_arn
}


module "redshift" {
  source = "./modules/redshift"

  project_name = var.project_name
  region       = var.region

  redshift_master_username = var.redshift_master_username

  redshift_master_password = var.redshift_master_password

  # If you want the module to read secret from SecretsManager
  #secret_name  = module.secrets.redshift_secret_name
}
