variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "function_sa_name" {
  description = "Service account ID for Cloud Function"
  type        = string
}