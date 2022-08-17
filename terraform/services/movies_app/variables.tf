# Movies App
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

variable "movies_app_ddb_table" {
  description = "The Dynamo DB Table Name"
  type        = string
}

variable "movies_app_ddb_billing_mode" {
  description = "The Billing Mode for the Dynamo DB Table"
  type        = string
}

variable "movies_app_ddb_read_capacity" {
  description = "The Dynamo DB Read Capacity"
  type        = number
}

variable "movies_app_ddb_write_capacity" {
  description = "The Dynamo DB Write Capacity"
  type        = number
}

variable "movies_app_ddb_hash_key" {
  description = "The Dynamo DB Hash Key"
  type        = string
}

variable "movies_app_ddb_range_key" {
  description = "The Dynamo DB Range Key"
  type        = string
}

variable "layers" {
  description = "The Lambda Layers ARNs"
  type        = list(string)
}
