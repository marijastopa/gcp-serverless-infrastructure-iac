resource "google_service_account" "function" {
  project      = var.project_id
  account_id   = var.function_sa_name
  display_name = "Cloud Function SA - ${var.environment}"
  description  = "Service account for Cloud Function runtime"
}

resource "google_service_account" "terraform" {
  project      = var.project_id
  account_id   = "${var.environment}-terraform-sa"
  display_name = "Terraform SA - ${var.environment}"
  description  = "Service account for Terraform deployments via GitHub Actions"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "${var.environment}-github-pool"
  display_name              = "GitHub Actions Pool - ${var.environment}"
  description               = "Identity pool for GitHub Actions deployments"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.environment}-github-provider"
  display_name                       = "GitHub Actions Provider - ${var.environment}"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}

locals {
  terraform_roles = [
    "roles/compute.networkAdmin",        
    "roles/compute.securityAdmin",       
    "roles/vpcaccess.admin",          
    "roles/cloudfunctions.admin",     
    "roles/run.admin",                
    "roles/storage.admin",             
    "roles/secretmanager.admin",     
    "roles/iam.serviceAccountAdmin",     
    "roles/iam.serviceAccountUser",   
    "roles/resourcemanager.projectIamAdmin",  
    "roles/compute.loadBalancerAdmin",  
  ]
}

resource "google_project_iam_member" "terraform_roles" {
  for_each = toset(local.terraform_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.terraform.email}"
}