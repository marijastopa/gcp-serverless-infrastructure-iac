locals {
  name_prefix = "${var.prefix}-${var.environment}"

  labels = {
    environment = var.environment
    managed-by  = "terraform"
    project     = "iac-serverless"
  }
}

module "networking" {
  source = "../../modules/networking"

  project_id     = var.project_id
  region         = var.region
  environment    = var.environment
  vpc_name       = "${local.name_prefix}-vpc"
  subnet_cidr    = "10.10.1.0/24"
  connector_cidr = "10.10.2.0/28"

  nat_log_filter          = "ALL"
  nat_min_ports_per_vm    = 256
  connector_max_instances = 10
}

module "service_accounts" {
  source = "../../modules/service-accounts"

  project_id        = var.project_id
  environment       = var.environment
  function_sa_name  = "${local.name_prefix}-function-sa"
  github_repository = var.github_repository
}

module "secret_manager" {
  source = "../../modules/secret-manager"

  project_id            = var.project_id
  secret_id             = "${local.name_prefix}-app-secret"
  service_account_email = module.service_accounts.function_sa_email
}

module "app_storage" {
  source = "../../modules/storage"

  project_id            = var.project_id
  bucket_name           = "${var.project_id}-app-data-${var.environment}"
  location              = var.region
  service_account_email = module.service_accounts.function_sa_email
  force_destroy         = false
}

module "deployment_storage" {
  source = "../../modules/storage"

  project_id            = var.project_id
  bucket_name           = "${var.project_id}-function-deploy-${var.environment}"
  location              = var.region
  service_account_email = module.service_accounts.function_sa_email
  force_destroy         = false
}

module "cloud_function" {
  source = "../../modules/cloud-function"

  project_id             = var.project_id
  region                 = var.region
  function_name          = "${local.name_prefix}-function"
  service_account_email  = module.service_accounts.function_sa_email
  vpc_connector          = module.networking.connector_id
  secret_id              = module.secret_manager.secret_id
  bucket_name            = module.app_storage.bucket_name
  deployment_bucket_name = module.deployment_storage.bucket_name
  source_dir             = "${path.root}/../../../function/src"

  memory_mb       = 512
  timeout_seconds = 120
  min_instances   = 1
  max_instances   = 20

  labels = local.labels
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  project_id            = var.project_id
  region                = var.region
  lb_name               = "${local.name_prefix}-lb"
  function_url          = module.cloud_function.function_url
  function_service_name = module.cloud_function.function_name

  enable_https       = true
  domain             = var.domain
  enable_cloud_armor = true
}