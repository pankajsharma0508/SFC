# resource "aws_api_gateway_rest_api" "calculator_api" {
#   name = "calculator_api"
# }

# resource "aws_api_gateway_resource" "calculator_resource" {
#   rest_api_id = aws_api_gateway_rest_api.calculator_api.id
#   parent_id   = aws_api_gateway_rest_api.calculator_api.root_resource_id
#   path_part   = var.endpoint
# }

# resource "aws_api_gateway_method" "calculator_method" {
#   rest_api_id   = aws_api_gateway_rest_api.calculator_api.id
#   resource_id   = aws_api_gateway_resource.calculator_resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "calculator_api_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.calculator_api.id
#   resource_id             = aws_api_gateway_resource.calculator_resource.id
#   http_method             = aws_api_gateway_method.calculator_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.calculator.invoke_arn
# }

# resource "aws_lambda_permission" "calculator_permission" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:Invokefunction"
#   function_name = aws_lambda_function.calculator.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.calculator_api.id}/*/${aws_api_gateway_method.calculator_method.http_method}${aws_api_gateway_resource.calculator_resource.path}"
# }

# resource "aws_api_gateway_deployment" "calculator" {
#   rest_api_id = aws_api_gateway_rest_api.calculator_api.id
#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_integration.calculator_api_integration))
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
#   depends_on = [aws_api_gateway_method.calculator_method, aws_api_gateway_integration.calculator_api_integration]
# }

# resource "aws_api_gateway_stage" "calculator_dev" {
#   deployment_id = aws_api_gateway_deployment.calculator.id
#   rest_api_id   = aws_api_gateway_rest_api.calculator_api.id
#   stage_name    = "dev"
# }