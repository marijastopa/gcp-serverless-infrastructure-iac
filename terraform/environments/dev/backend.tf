terraform {
  backend "gcs" {
    bucket = "YOUR_PROJECT_ID-tfstate-dev"
    prefix = "terraform/state"
  }
}