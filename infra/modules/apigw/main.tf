resource "aws_iam_role" "apigw_cloudwatch_role" {
  name = "apigw-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigw_logs" {
  role       = aws_iam_role.apigw_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project_name}-api"
}

##  Adidas Resource and Method

resource "aws_api_gateway_resource" "adidas" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "adidas"
}


resource "aws_api_gateway_method" "post_adidas" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.adidas.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "adidas_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.adidas.id
  http_method             = aws_api_gateway_method.post_adidas.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.adidas_invoke_arn
  
}

##  Shopee Resource and Method


resource "aws_api_gateway_resource" "shopee" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "shopee"
}


resource "aws_api_gateway_method" "post_shopee" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.shopee.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "shopee_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.shopee.id
  http_method             = aws_api_gateway_method.post_shopee.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.shopee_invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.adidas_lambda_integration,
  aws_api_gateway_integration.shopee_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch_role.arn
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "prod"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw_logs.arn
    format = jsonencode({
      requestId    = "$context.requestId"
      ip           = "$context.identity.sourceIp"
      requestTime  = "$context.requestTime"
      httpMethod   = "$context.httpMethod"
      resourcePath = "$context.resourcePath"
      status       = "$context.status"
      protocol     = "$context.protocol"
    })
  }

  xray_tracing_enabled = true

  depends_on = [
    aws_api_gateway_account.account
  ]
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/api-gateway/${var.project_name}-api"
  retention_in_days = 14
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [name]
  }
}

resource "aws_lambda_permission" "apigw_adidas" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.adidas_function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_shopee" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.shopee_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
