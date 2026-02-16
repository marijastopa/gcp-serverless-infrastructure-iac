# Grant Load Balancer permission to invoke Cloud Function
resource "google_cloud_run_service_iam_member" "lb_invoker" {
  project  = var.project_id
  location = var.region
  service  = var.function_service_name
  role     = "roles/run.invoker"
  member   = "allUsers"
}