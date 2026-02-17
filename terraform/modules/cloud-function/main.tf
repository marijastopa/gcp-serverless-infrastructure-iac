data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "/tmp/function-source-${var.function_name}.zip"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "functions/${var.function_name}-${data.archive_file.function_source.output_md5}.zip"
  bucket = var.deployment_bucket_name
  source = data.archive_file.function_source.output_path
}

resource "google_cloudfunctions2_function" "function" {
  project  = var.project_id
  name     = var.function_name
  location = var.region

  labels = var.labels
  
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = var.deployment_bucket_name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    max_instance_count    = var.max_instances
    min_instance_count    = var.min_instances
    available_memory      = "${var.memory_mb}Mi"
    timeout_seconds       = var.timeout_seconds
    service_account_email = var.service_account_email

    vpc_connector                 = var.vpc_connector
    vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
    ingress_settings              = "INTERNAL_ONLY"

    environment_variables = {
      SECRET_ID   = var.secret_id
      BUCKET_NAME = var.bucket_name
      GCP_PROJECT_ID = var.project_id
      ENVIRONMENT    = var.environment
    }
  }

  lifecycle {
    replace_triggered_by = [
      google_storage_bucket_object.function_zip
    ]
  }
}