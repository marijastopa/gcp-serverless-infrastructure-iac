resource "google_storage_bucket_iam_member" "object_viewer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "object_creator" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account_email}"
}