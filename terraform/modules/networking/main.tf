resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.vpc_name}-main-${var.region}"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "connector" {
  name          = "${var.vpc_name}-connector-${var.region}"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.connector_cidr

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name    = "${var.vpc_name}-nat"
  project = var.project_id
  region  = var.region
  router  = google_compute_router.router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.main.id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.connector.id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  log_config {
    enable = true
    filter = "ALL"
  }

  min_ports_per_vm = var.nat_min_ports_per_vm
}

resource "google_vpc_access_connector" "connector" {
  name    = "${var.vpc_name}-connector"
  project = var.project_id
  region  = var.region

  subnet {
    name = google_compute_subnetwork.connector.name
  }

  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = var.connector_max_instances
}