output "base_url" {
  description = "Base URL for API Gateway stage."
  value       = module.api_gw_stage_secret_app.base_url
}