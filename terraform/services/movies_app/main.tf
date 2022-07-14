module "ddb_table_movies" {
  source         = "./../../modules/ddb_table"
  tags           = var.tags
  table_name     = var.movies_app_ddb_table
  billing_mode   = var.movies_app_ddb_billing_mode
  read_capacity  = var.movies_app_ddb_read_capacity
  write_capacity = var.movies_app_ddb_write_capacity
  hash_key       = var.movies_app_ddb_hash_key
  range_key      = var.movies_app_ddb_range_key
  attributes = [
    { name = "year", type = "N" },
    { name = "title", type = "S" }
  ]
}

data "aws_iam_policy_document" "movies_app" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:*:*:table/${module.ddb_table_movies.id}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "archive_file" "movies_app" {
  type        = "zip"
  source_dir  = "./../src/movies_app"
  output_path = "./../build/movies_app.zip"
}

module "lambda_movies_app" {
  source                   = "./../../modules/lambda"
  tags                     = var.tags
  artifact_source          = data.archive_file.movies_app.output_path
  artifact_bucket_id       = var.artifact_bucket_id
  artifact_s3_key          = "movies_app/movies_app.zip"
  name                     = "movies_app"
  runtime                  = "python3.8"
  handler                  = "movies.lambda_handler"
  source_code_hash         = data.archive_file.movies_app.output_base64sha256
  iam_policy_json_document = data.aws_iam_policy_document.movies_app.json
  log_retention_in_days    = var.log_retention_in_days
  layers = [
    "arn:aws:lambda:${var.aws_region}:${var.aws_provided_layer_account_id}:layer:${var.aws_provided_layer_name}:${var.aws_provided_layer_version}"
  ]
  environment_vars = [
    {
      DDB_TABLE = "${var.movies_app_ddb_table}"
    }
  ]
}

module "lambda_permission_movies_app" {
  source      = "./../../modules/lambda_permission"
  lambda_name = module.lambda_movies_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = var.api_gateway_execution_arn
}

module "api_gw_stage_movies_app" {
  source           = "./../../modules/api_gateway_stage"
  tags             = var.tags
  name             = "${module.lambda_movies_app.function_name}-stage"
  api_gw_id        = var.api_gw_id
  cw_log_group_arn = var.api_gw_log_group_arn
}

module "api_gw_integration_movies_app" {
  source             = "./../../modules/api_gateway_integration"
  api_gw_id          = var.api_gw_id
  integration_uri    = module.lambda_movies_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_movies_app" {
  source    = "./../../modules/api_gateway_route"
  api_gw_id = var.api_gw_id
  route_key = "POST /movies"
  target    = "integrations/${module.api_gw_integration_movies_app.id}"
}
