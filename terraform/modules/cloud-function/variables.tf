variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "function_name" {
  description = "Cloud Function name"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for function runtime"
  type        = string
}

variable "vpc_connector" {
  description = "VPC connector name for private network access"
  type        = string
}

variable "secret_id" {
  description = "Secret Manager secret ID"
  type        = string
}

variable "bucket_name" {
  description = "Storage bucket name for application data"
  type        = string
}

variable "deployment_bucket_name" {
  description = "Storage bucket name for function deployment artifacts"
  type        = string
}

variable "runtime" {
  description = "Function runtime"
  type        = string
  default     = "python311"
}

variable "entry_point" {
  description = "Function entry point"
  type        = string
  default     = "main"
}

variable "memory_mb" {
  description = "Memory in MB for function"
  type        = number
  default     = 256

  validation {
    condition     = contains([128, 256, 512, 1024, 2048, 4096, 8192], var.memory_mb)
    error_message = "Memory must be one of: 128, 256, 512, 1024, 2048, 4096, 8192"
  }
}

variable "timeout_seconds" {
  description = "Timeout in seconds"
  type        = number
  default     = 60

  validation {
    condition     = var.timeout_seconds >= 1 && var.timeout_seconds <= 540
    error_message = "Timeout must be between 1 and 540 seconds"
  }
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "source_dir" {
  description = "Path to function source code directory"
  type        = string
}

variable "labels" {
  description = "Labels for the function"
  type        = map(string)
  default     = {}
}