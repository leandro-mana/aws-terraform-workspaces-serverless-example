variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

# Generic
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

variable "artifact_bucket_id" {
  description = "The S3 Bucket Id for Lambda artifacts"
  type        = string
}

# Secret Manager
# variable "secret_value" {
#   description = "The JSON Object for the Secret Value"
#   type        = map(any)
#   sensitive   = true
#   nullable    = false
# }

# Secret Lambda
variable "layers" {
  description = "The Lambda Layers ARNs"
  type        = list(string)
}
