data "archive_file" "hello_app" {
  type        = "zip"
  source_dir  = "./../src/hello_app"
  output_path = "./../build/hello_app.zip"
}

module "generic_iam_policy" {
  source                   = "./../../manifests/iam_policy"
  policy_name              = "hello-generic-policy"
  iam_policy_json_document = file("./manifests/iam_policies/lambda_generic.json")
}

module "lambda_hello_app" {
  source             = "./../../manifests/lambda"
  artifact_source    = data.archive_file.hello_app.output_path
  artifact_bucket_id = var.artifact_bucket_id
  artifact_s3_key    = "hello_app/hello_app.zip"
  name               = "hello_app"
  runtime            = "python3.8"
  handler            = "hello.lambda_handler"
  source_code_hash   = data.archive_file.hello_app.output_base64sha256
  iam_arn_policies = [
    module.generic_iam_policy.arn
  ]
  log_retention_in_days = var.log_retention_in_days
  layers                = var.layers
  environment_vars      = []
}

module "lambda_permission_hello_app" {
  source      = "./../../manifests/lambda_permission"
  lambda_name = module.lambda_hello_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = var.api_gateway_execution_arn
}

module "api_gw_stage_hello_app" {
  source           = "./../../manifests/api_gateway_stage"
  name             = "${module.lambda_hello_app.function_name}-stage"
  api_gw_id        = var.api_gw_id
  cw_log_group_arn = var.api_gw_log_group_arn
}

module "api_gw_integration_hello_app" {
  source             = "./../../manifests/api_gateway_integration"
  api_gw_id          = var.api_gw_id
  integration_uri    = module.lambda_hello_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_hello_app" {
  source    = "./../../manifests/api_gateway_route"
  api_gw_id = var.api_gw_id
  route_key = "GET /hello"
  target    = "integrations/${module.api_gw_integration_hello_app.id}"
}
