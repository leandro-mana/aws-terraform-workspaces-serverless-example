# Hello App
variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

variable "artifact_bucket_id" {
  description = "The S3 Bucket Id for Lambda artifacts"
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "The API GW Execution ARN"
  type        = string
}

variable "api_gw_id" {
  description = "The API GW Id"
  type        = string
}

variable "api_gw_log_group_arn" {
  description = "The API GW Cloudwatch Log group ARN"
  type        = string
}

variable "layers" {
  description = "The Lambda Layers ARNs"
  type        = list(string)
}
