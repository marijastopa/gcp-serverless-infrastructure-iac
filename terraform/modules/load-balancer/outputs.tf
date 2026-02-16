output "lb_ip_address" {
  description = "Load balancer IP address"
  value       = google_compute_global_forwarding_rule.http.ip_address
}

output "lb_http_url" {
  description = "Load balancer HTTP URL"
  value       = "http://${google_compute_global_forwarding_rule.http.ip_address}"
}

output "lb_https_url" {
  description = "Load balancer HTTPS URL (if enabled)"
  value       = var.enable_https ? "https://${var.domain}" : null
}