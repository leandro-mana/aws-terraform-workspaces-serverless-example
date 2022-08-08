# Modular Infrastructure

######################
# S3 Artifact Bucket #
######################
module "s3_artifact_bucket" {
  count       = var.deploy_s3_artifact_bucket == true ? 1 : 0
  source      = "./modules/s3_artifact_bucket"
  bucket_name = "${var.environment}-${var.project}-${var.aws_region}-artifacts"
}

###############
# API Gateway #
###############
module "api_gateway" {
  count                 = var.deploy_api_gw == true ? 1 : 0
  source                = "./modules/api_gateway"
  name                  = "hello_app"
  protocol_type         = "HTTP"
  log_retention_in_days = var.log_retention_in_days
}

#############
# hello_app #
#############
module "hello_app" {
  count                     = var.deploy_hello_app == true ? 1 : 0
  source                    = "./services/hello_app"
  aws_region                = var.aws_region
  log_retention_in_days     = var.log_retention_in_days
  artifact_bucket_id        = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn = module.api_gateway[0].execution_arn
  api_gw_id                 = module.api_gateway[0].id
  api_gw_log_group_arn      = module.api_gateway[0].cw_log_group_arn
}

##############
# movies_app #
##############
module "movies_app" {
  count                         = var.deploy_movies_app == true ? 1 : 0
  source                        = "./services/movies_app"
  aws_region                    = var.aws_region
  log_retention_in_days         = var.log_retention_in_days
  artifact_bucket_id            = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn     = module.api_gateway[0].execution_arn
  api_gw_id                     = module.api_gateway[0].id
  api_gw_log_group_arn          = module.api_gateway[0].cw_log_group_arn
  movies_app_ddb_table          = var.movies_app_ddb_table
  movies_app_ddb_billing_mode   = var.movies_app_ddb_billing_mode
  movies_app_ddb_read_capacity  = var.movies_app_ddb_read_capacity
  movies_app_ddb_write_capacity = var.movies_app_ddb_write_capacity
  movies_app_ddb_hash_key       = var.movies_app_ddb_hash_key
  movies_app_ddb_range_key      = var.movies_app_ddb_range_key
}

##############
# Secret App #
##############
module "secret_app" {
  count                     = var.deploy_secret_app == true ? 1 : 0
  source                    = "./services/secret_app"
  secret_value              = var.secret_app_secret_value
  aws_region                = var.aws_region
  log_retention_in_days     = var.log_retention_in_days
  artifact_bucket_id        = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn = module.api_gateway[0].execution_arn
  api_gw_id                 = module.api_gateway[0].id
  api_gw_log_group_arn      = module.api_gateway[0].cw_log_group_arn
}