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
  default     = "dev"
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "iac"
}

variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
}