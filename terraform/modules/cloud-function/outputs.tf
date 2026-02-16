output "function_name" {
  description = "Cloud Function name"
  value       = google_cloudfunctions2_function.function.name
}

output "function_url" {
  description = "Cloud Function URL"
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}

output "function_id" {
  description = "Cloud Function ID"
  value       = google_cloudfunctions2_function.function.id
}

output "service_name" {
  description = "Cloud Run service name (for Load Balancer backend)"
  value       = google_cloudfunctions2_function.function.name
}