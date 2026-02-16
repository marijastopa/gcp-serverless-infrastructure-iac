variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "lb_name" {
  description = "Load balancer name prefix"
  type        = string
}

variable "function_url" {
  description = "Cloud Function URL"
  type        = string
}

variable "function_service_name" {
  description = "Cloud Run service name (Cloud Function Gen2)"
  type        = string
}

variable "enable_https" {
  description = "Enable HTTPS with managed certificate"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Domain for managed SSL certificate (required if enable_https = true)"
  type        = string
  default     = ""
}

variable "enable_cloud_armor" {
  description = "Enable Cloud Armor security policy"
  type        = bool
  default     = false
}