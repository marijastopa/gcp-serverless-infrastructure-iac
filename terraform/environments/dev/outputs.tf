output "load_balancer_ip" {
  description = "Load balancer IP address"
  value       = module.load_balancer.lb_ip_address
}

output "load_balancer_url" {
  description = "Load balancer URL"
  value       = module.load_balancer.lb_http_url
}

output "function_name" {
  description = "Cloud Function name"
  value       = module.cloud_function.function_name
}

output "app_bucket_name" {
  description = "Application storage bucket name"
  value       = module.app_storage.bucket_name
}

output "secret_id" {
  description = "Secret Manager secret ID"
  value       = module.secret_manager.secret_id
}

output "vpc_name" {
  description = "VPC network name"
  value       = module.networking.vpc_name
}