terraform {
  backend "gcs" {
    bucket = "iac-serverless-tfstate-prod"
    prefix = "terraform/state"
  }
}