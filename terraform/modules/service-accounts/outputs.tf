output "function_sa_email" {
  description = "Cloud Function service account email"
  value       = google_service_account.function.email
}

output "function_sa_id" {
  description = "Cloud Function service account ID"
  value       = google_service_account.function.id
}

output "function_sa_name" {
  description = "Cloud Function service account name"
  value       = google_service_account.function.name
}

output "function_sa_member" {
  description = "IAM member format for Cloud Function SA"
  value       = "serviceAccount:${google_service_account.function.email}"
}

output "function_sa_unique_id" {
  description = "Unique ID for Cloud Function SA"
  value       = google_service_account.function.unique_id
}

output "terraform_sa_email" {
  description = "Terraform service account email for CI/CD"
  value       = google_service_account.terraform.email
}

output "workload_identity_provider" {
  description = "Workload Identity Provider resource name for GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.github.name
}