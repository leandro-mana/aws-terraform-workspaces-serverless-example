variable "source_dir" {
  description = "Source code directory"
  type        = string
}

variable "output_path" {
  description = "Layer artifact output path"
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

variable "layer_name" {
  description = "The AWS Lambda Layer name"
  type        = string
}

variable "skip_destroy" {
  description = "Boolean to whether to retain the old version of a previously deployed Lambda Layer"
  type        = bool
}

variable "compatible_runtimes" {
  description = "The list of compatibles runtimes related with the Lambda Layer"
  type        = list(string)
}
