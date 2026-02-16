output "secret_id" {
  description = "Secret ID for use in CI/CD"
  value       = google_secret_manager_secret.secret.secret_id
}

output "secret_name" {
  description = "Full secret resource name"
  value       = google_secret_manager_secret.secret.name
}