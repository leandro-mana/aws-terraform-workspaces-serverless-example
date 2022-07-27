output "hello_app_base_url" {
  description = "Base URL for API Gateway stage."
  value       = var.deploy_hello_app == true ? module.hello_app[0].base_url : null
}

output "movies_app_base_url" {
  description = "Base URL for API Gateway stage."
  value       = var.deploy_movies_app == true ? module.movies_app[0].base_url : null
}

output "secret_app_base_url" {
  description = "Base URL for API Gateway stage."
  value       = var.deploy_secret_app == true ? module.secret_app[0].base_url : null
}
