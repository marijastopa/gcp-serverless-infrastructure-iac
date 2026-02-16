variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "secret_id" {
  description = "Secret ID"
  type        = string
}

variable "service_account_email" {
  description = "Service account email to grant access"
  type        = string
}