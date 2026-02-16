# GCP Serverless Infrastructure - IaC

Terraform-based infrastructure for serverless workloads on Google Cloud Platform. Implements private networking, secret management, and enterprise security controls across multiple environments.

## Structure
```
terraform/
 - modules/          # Reusable components
 - environments/     # Dev and prod configs
 - backend-setup/    # State bucket setup
```

## Setup
```bash
# 1. Configure GCP project
gcloud config set project YOUR_PROJECT_ID

# 2. Enable APIs
./scripts/enable-apis.sh

# 3. Create state backend
./scripts/create-terraform-backend.sh dev

# 4. Deploy
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

## Architecture

- VPC with private subnets
- Cloud Functions Gen2 with VPC connector
- Secret Manager for credentials
- Cloud Storage with private access
- Application Load Balancer
- Service accounts with minimal IAM permissions

## Environments

- **dev**: Development environment
- **prod**: Production environment (manual approval required)

See `docs/` for detailed documentation.