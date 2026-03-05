resource "google_compute_region_network_endpoint_group" "function_neg" {
  project               = var.project_id
  name                  = "${var.lb_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = var.function_service_name
  }
}

resource "google_compute_backend_service" "function_backend" {
  project = var.project_id
  name    = "${var.lb_name}-backend"

  protocol = "HTTP"

  backend {
    group = google_compute_region_network_endpoint_group.function_neg.id
  }

  security_policy = var.enable_cloud_armor ? google_compute_security_policy.policy[0].id : null

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "${var.lb_name}-url-map"
  default_service = google_compute_backend_service.function_backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  project = var.project_id
  name    = "${var.lb_name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http" {
  project     = var.project_id
  name        = "${var.lb_name}-http-rule"
  target      = google_compute_target_http_proxy.http_proxy.id
  port_range  = "80"
  ip_protocol = "TCP"
}

# HTTPS configuration
resource "google_compute_managed_ssl_certificate" "cert" {
  count   = var.enable_https ? 1 : 0
  project = var.project_id
  name    = "${var.lb_name}-cert"

  managed {
    domains = [var.domain]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  count           = var.enable_https ? 1 : 0
  project         = var.project_id
  name            = "${var.lb_name}-https-proxy"
  url_map         = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.cert[0].id]
}

resource "google_compute_global_forwarding_rule" "https" {
  count       = var.enable_https ? 1 : 0
  project     = var.project_id
  name        = "${var.lb_name}-https-rule"
  target      = google_compute_target_https_proxy.https_proxy[0].id
  port_range  = "443"
  ip_protocol = "TCP"
}

# Cloud Armor security policy
resource "google_compute_security_policy" "policy" {
  count   = var.enable_cloud_armor ? 1 : 0
  project = var.project_id
  name    = "${var.lb_name}-security-policy"

  rule {
    action   = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }

  rule {
    action   = "rate_based_ban"
    priority = 100
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      enforce_on_key = "IP"
      rate_limit_threshold {
        count        = 100
        interval_sec = 60
      }
      ban_duration_sec = 600
    }
    description = "Rate limiting: 100 requests per minute"
  }
}