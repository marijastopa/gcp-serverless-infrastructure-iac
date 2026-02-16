resource "google_service_account" "function" {
  project      = var.project_id
  account_id   = var.function_sa_name
  display_name = "Cloud Function SA - ${var.environment}"
  description  = "Service account for Cloud Function runtime"
}