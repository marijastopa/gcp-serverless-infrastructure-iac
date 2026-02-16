variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "bucket_name" {
  description = "Storage bucket name"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "europe-west1"
}

variable "service_account_email" {
  description = "Service account email to grant access"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion with objects inside"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable access logging"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "Bucket for access logs (required if enable_logging = true)"
  type        = string
  default     = ""
}