variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for main subnet"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Must be valid IPv4 CIDR range"
  }
}

variable "connector_cidr" {
  description = "CIDR range for VPC connector (must be /28)"
  type        = string
  default     = "10.0.2.0/28"

  validation {
    condition     = can(regex("/28$", var.connector_cidr))
    error_message = "VPC connector CIDR must be /28 range"
  }
}

variable "nat_min_ports_per_vm" {
  description = "Minimum ports per VM for NAT"
  type        = number
  default     = 128

  validation {
    condition     = var.nat_min_ports_per_vm >= 64 && var.nat_min_ports_per_vm <= 65536
    error_message = "NAT min ports must be between 64 and 65536"
  }
}

variable "nat_log_filter" {
  description = "NAT logging filter level"
  type        = string
  default     = "ERRORS_ONLY"

  validation {
    condition     = contains(["ERRORS_ONLY", "TRANSLATIONS_ONLY", "ALL"], var.nat_log_filter)
    error_message = "NAT log filter must be ERRORS_ONLY, TRANSLATIONS_ONLY, or ALL"
  }
}

variable "connector_max_instances" {
  description = "Maximum instances for VPC connector"
  type        = number
  default     = 3

  validation {
    condition     = var.connector_max_instances >= 2 && var.connector_max_instances <= 10
    error_message = "Connector max instances must be between 2 and 10"
  }
}