resource "google_storage_bucket" "bucket" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.location
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  dynamic "logging" {
    for_each = var.enable_logging ? [1] : []
    content {
      log_bucket = var.log_bucket
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 30
    }
    action {
      type = "Delete"
    }
  }
}