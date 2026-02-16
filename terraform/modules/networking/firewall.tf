# Default deny all ingress
resource "google_compute_firewall" "deny_all_ingress" {
  name    = "${var.vpc_name}-deny-all-ingress"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Allow HTTPS for internal communication
resource "google_compute_firewall" "allow_internal_https" {
  name    = "${var.vpc_name}-allow-internal-https"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [
    var.subnet_cidr,
    var.connector_cidr
  ]
}

# Allow ICMP for network diagnostics
resource "google_compute_firewall" "allow_internal_icmp" {
  name    = "${var.vpc_name}-allow-internal-icmp"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.subnet_cidr,
    var.connector_cidr
  ]
}

# Allow health checks from GCP load balancers
resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.vpc_name}-allow-health-checks"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
}

# Allow HTTPS egress to Google APIs
resource "google_compute_firewall" "allow_https_egress" {
  name    = "${var.vpc_name}-allow-https-egress"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 1000
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [
    "199.36.153.4/30",
    "199.36.153.8/30"
  ]
}

# Allow DNS egress
resource "google_compute_firewall" "allow_dns_egress" {
  name    = "${var.vpc_name}-allow-dns-egress"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 1000
  direction = "EGRESS"

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  destination_ranges = ["0.0.0.0/0"]
}

# Default deny all egress
resource "google_compute_firewall" "deny_all_egress" {
  name    = "${var.vpc_name}-deny-all-egress"
  project = var.project_id
  network = google_compute_network.vpc.name

  priority  = 65534
  direction = "EGRESS"

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}