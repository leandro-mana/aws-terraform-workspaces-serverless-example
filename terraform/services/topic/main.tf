data "archive_file" "topic_app" {
  type        = "zip"
  source_dir  = "./../src/topic_app"
  output_path = "./../build/topic_app.zip"
}

module "generic_iam_policy" {
  source                   = "./../../manifests/iam_policy"
  policy_name              = "movies-generic-policy"
  iam_policy_json_document = file("./manifests/iam_policies/lambda_generic.json")
}

module "lambda_movies_app" {
  source             = "./../../manifests/lambda"
  artifact_source    = data.archive_file.topic_app.output_path
  artifact_bucket_id = var.artifact_bucket_id
  artifact_s3_key    = "topic_app/topic_app.zip"
  name               = "topic_app"
  runtime            = "python3.8"
  handler            = "topic.lambda_handler"
  source_code_hash   = data.archive_file.topic_app.output_base64sha256
  iam_arn_policies = [
    module.generic_iam_policy.arn
  ]
  log_retention_in_days = var.log_retention_in_days
  layers                = var.layers
  environment_vars = [
    {
      DDB_TABLE = "${var.movies_app_ddb_table}"
    }
  ]
}
