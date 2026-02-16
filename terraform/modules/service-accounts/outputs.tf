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
  description = "Cloud Function service account member format"
  value       = "serviceAccount:${google_service_account.function.email}"
}