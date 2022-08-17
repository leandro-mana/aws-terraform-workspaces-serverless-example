output "secret_name" {
  description = "The Secret Name"
  value       = aws_secretsmanager_secret.secret.id
}

output "secret_iam_policy_arn" {
  description = "The IAM Policy of the Secret"
  value       = aws_iam_policy.secret_policy.arn
}