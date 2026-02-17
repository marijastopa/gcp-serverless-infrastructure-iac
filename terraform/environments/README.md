# Environments

Before deploying any environment, complete the following steps:

## Prerequisites

1. Configure GCP project:
```bash
gcloud config set project YOUR_PROJECT_ID
```

2. Enable required APIs:
```bash
./scripts/enable-apis.sh
```

3. Create Terraform state bucket:
```bash
./scripts/create-terraform-backend.sh dev
./scripts/create-terraform-backend.sh prod
```

4. Update backend.tf with your project ID:
```bash
# terraform/environments/dev/backend.tf
bucket = "YOUR_PROJECT_ID-tfstate-dev"

# terraform/environments/prod/backend.tf
bucket = "YOUR_PROJECT_ID-tfstate-prod"
```

5. Configure GitHub Secrets (see main README)

## Deployment Order

Always deploy dev before prod:
```bash
# Dev
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

# Prod (after dev is verified)
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```