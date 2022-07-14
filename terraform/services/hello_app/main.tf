data "archive_file" "hello_app" {
  type        = "zip"
  source_dir  = "./../src/hello_app"
  output_path = "./../build/hello_app.zip"
}

module "lambda_hello_app" {
  source                   = "./../../modules/lambda"
  tags                     = var.tags
  artifact_source          = data.archive_file.hello_app.output_path
  artifact_bucket_id       = var.artifact_bucket_id
  artifact_s3_key          = "hello_app/hello_app.zip"
  name                     = "hello_app"
  runtime                  = "python3.8"
  handler                  = "hello.lambda_handler"
  source_code_hash         = data.archive_file.hello_app.output_base64sha256
  iam_policy_json_document = file("./modules/iam_policies/lambda_generic.json")
  log_retention_in_days    = var.log_retention_in_days
  layers = [
    "arn:aws:lambda:${var.aws_region}:${var.aws_provided_layer_account_id}:layer:${var.aws_provided_layer_name}:${var.aws_provided_layer_version}"
  ]
  environment_vars = []
}

module "lambda_permission_hello_app" {
  source      = "./../../modules/lambda_permission"
  lambda_name = module.lambda_hello_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = var.api_gateway_execution_arn
}

module "api_gw_stage_hello_app" {
  source           = "./../../modules/api_gateway_stage"
  tags             = var.tags
  name             = "${module.lambda_hello_app.function_name}-stage"
  api_gw_id        = var.api_gw_id
  cw_log_group_arn = var.api_gw_log_group_arn
}

module "api_gw_integration_hello_app" {
  source             = "./../../modules/api_gateway_integration"
  api_gw_id          = var.api_gw_id
  integration_uri    = module.lambda_hello_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_hello_app" {
  source    = "./../../modules/api_gateway_route"
  api_gw_id = var.api_gw_id
  route_key = "GET /hello"
  target    = "integrations/${module.api_gw_integration_hello_app.id}"
}
