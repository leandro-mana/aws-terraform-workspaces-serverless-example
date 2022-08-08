variable "secret_name" {
  description = "The Name of the Secret"
  type        = string
}

variable "recovery_window_in_days" {
  description = "The amount of days to recover the Secret"
  type        = number
  default     = 0
}

variable "secret_value" {
  description = "The JSON Object for the Secret Value"
  type        = map(any)
  sensitive   = true
  nullable    = false
}