# S3 Artifact
variable "artifact_source" {
  description = "The path for the Lambda artifact"
  type        = string

}

variable "artifact_bucket_id" {
  description = "The S3 Bucket Id for Lambda artifacts"
  type        = string
}

variable "artifact_s3_key" {
  description = "The S3 Bucket key for the Lambda artifact"
  type        = string
}

variable "iam_arn_policies" {
  description = "The JSON policies ARNs List to attach to the Lambda IAM Role"
  type        = list(any)
}

# Cloudwatch log group
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

# Lambda
variable "name" {
  description = "The Lambda name"
  type        = string
}

variable "runtime" {
  description = "The Lambda runtime name"
  type        = string
}

variable "handler" {
  description = "The Lambda handler"
  type        = string
}

variable "source_code_hash" {
  description = "The Lambda source code hash"
  type        = string
}

variable "layers" {
  description = "The Lambda Layers ARNs"
  type        = list(string)
}

variable "environment_vars" {
  description = "The Lambda Environmental variables"
  type        = list(any)
}