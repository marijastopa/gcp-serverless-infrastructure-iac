output "vpc_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "VPC self link"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "Main subnet ID"
  value       = google_compute_subnetwork.main.id
}

output "subnet_name" {
  description = "Main subnet name"
  value       = google_compute_subnetwork.main.name
}

output "connector_id" {
  description = "VPC connector ID"
  value       = google_vpc_access_connector.connector.id
}

output "connector_name" {
  description = "VPC connector name"
  value       = google_vpc_access_connector.connector.name
}

output "nat_name" {
  description = "Cloud NAT name"
  value       = google_compute_router_nat.nat.name
}