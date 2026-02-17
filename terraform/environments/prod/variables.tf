variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "iac"
}

variable "domain" {
  description = "Domain for HTTPS managed certificate"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
}