variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod"
  }
}

variable "region" {
  description = "GCP region for state bucket"
  type        = string
  default     = "europe-west1"
}

variable "terraform_sa_email" {
  description = "Terraform service account email to grant state access"
  type        = string
}