resource "aws_lambda_function" "hello_world_function" {
  function_name = "hello_world_function"
  filename      = data.archive_file.helloworlddotnet_zip.output_path

  role             = aws_iam_role.lambda_apigateway_iam_role.arn
  handler          = var.lambda_function_handler
  source_code_hash = filebase64sha256(data.archive_file.helloworlddotnet_zip.output_path)
  runtime          = var.lambda_runtime

  environment {
    variables = {
      currentLocation = "Salt Lake City"
    }
  }
  tags = {
    Name = "hello_world_function"
    owner_email = ""
    owner_name = "Emilio" 
    short_name = "hello_world_function"
    data_source = ""
  }
}

resource "aws_lambda_permission" "hello_world_function" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.hello_world_api.id}/${aws_api_gateway_deployment.hello_world_deploy.stage_name}/${aws_api_gateway_integration.hello_world_integration.integration_http_method}${aws_api_gateway_resource.hello_world_api_gateway.path}"
}

data "archive_file" "helloworlddotnet_zip" {                                                                                                                                                                                   
  type        = "zip"                                                                                                                                                                                                
  source_dir  = "../helloworlddotnet/HelloWorld/src/HelloWorld/bin/Debug/netcoreapp3.1/"                                                                                                                                                                                         
  output_path = "../helloworlddotnet/HelloWorld/src/HelloWorld/bin/helloworlddotnet-0.1.0-SNAPSHOT.zip"                                                                                                                                                                         
}