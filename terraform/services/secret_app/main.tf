data "archive_file" "secret_app" {
  type        = "zip"
  source_dir  = "./../src/secret_app"
  output_path = "./../build/secret_app.zip"
}

module "secrets_manager" {
  source       = "./../../modules/secrets_manager"
  secret_name  = "secret_app_secret"
  secret_value = var.secret_value
}

module "generic_iam_policy" {
  source                   = "./../../modules/iam_policy"
  policy_name              = "secret-generic-policy"
  iam_policy_json_document = file("./modules/iam_policies/lambda_generic.json")
}

module "lambda_secret_app" {
  source             = "./../../modules/lambda"
  artifact_source    = data.archive_file.secret_app.output_path
  artifact_bucket_id = var.artifact_bucket_id
  artifact_s3_key    = "secret_app/secret_app.zip"
  name               = "secret_app"
  runtime            = "python3.8"
  handler            = "secret.lambda_handler"
  source_code_hash   = data.archive_file.secret_app.output_base64sha256
  iam_arn_policies = [
    module.generic_iam_policy.arn,
    module.secrets_manager.secret_iam_policy_arn
  ]
  log_retention_in_days = var.log_retention_in_days
  layers = [
    "arn:aws:lambda:${var.aws_region}:${var.aws_provided_layer_account_id}:layer:${var.aws_provided_layer_name}:${var.aws_provided_layer_version}"
  ]
  environment_vars = []
}

module "lambda_permission_secret_app" {
  source      = "./../../modules/lambda_permission"
  lambda_name = module.lambda_secret_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = var.api_gateway_execution_arn
}

module "api_gw_stage_secret_app" {
  source           = "./../../modules/api_gateway_stage"
  name             = "${module.lambda_secret_app.function_name}-stage"
  api_gw_id        = var.api_gw_id
  cw_log_group_arn = var.api_gw_log_group_arn
}

module "api_gw_integration_secret_app" {
  source             = "./../../modules/api_gateway_integration"
  api_gw_id          = var.api_gw_id
  integration_uri    = module.lambda_secret_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_secret_app" {
  source    = "./../../modules/api_gateway_route"
  api_gw_id = var.api_gw_id
  route_key = "GET /secret"
  target    = "integrations/${module.api_gw_integration_secret_app.id}"
}
