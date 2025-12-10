variable "project_name" {
  type = string
}

variable "adidas_invoke_arn" {
  type = string
  default = module.lambda.adidas_invoke_arn
}

variable "adidas_function_name" {
  type = string
}

variable "shopee_invoke_arn" {
  type = string
  default = module.lambda.shopee_invoke_arn
}

variable "shopee_function_name" {
  type = string
}
