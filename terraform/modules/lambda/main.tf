resource "aws_s3_object" "artifact" {
  source = var.artifact_source
  bucket = var.artifact_bucket_id
  key    = var.artifact_s3_key
  etag   = filemd5(var.artifact_source)
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "policies_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  count      = length(var.iam_arn_policies)
  policy_arn = var.iam_arn_policies[count.index]
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = var.name
  s3_bucket        = var.artifact_bucket_id
  s3_key           = var.artifact_s3_key
  runtime          = var.runtime
  handler          = var.handler
  source_code_hash = var.source_code_hash
  role             = aws_iam_role.lambda_execution_role.arn
  layers           = var.layers != [] ? var.layers : []

  dynamic "environment" {
    for_each = var.environment_vars
    content {
      variables = environment.value
    }
  }
}
