output "state_bucket_name" {
  description = "Terraform state bucket name - use in backend.tf"
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_url" {
  description = "Terraform state bucket URL"
  value       = google_storage_bucket.terraform_state.url
}