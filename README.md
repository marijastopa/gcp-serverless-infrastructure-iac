# GCP Serverless Infrastructure

Terraform-based infrastructure for serverless workloads on Google Cloud Platform. Implements private networking, secret management, and enterprise security controls across multiple environments.

## What's deployed

- Cloud Function (Gen2) behind a Load Balancer
- Private VPC network with firewall rules
- Secret Manager for configuration
- Cloud Storage for files
- CI/CD via GitHub Actions

Public internet can only reach the Load Balancer. Everything else is private.

## Quick setup

**1. Enable APIs**
```bash
./scripts/create-state-buckets.sh
```

**2. Create state buckets**
```bash
cd terraform/backend-setup
terraform init
terraform apply -var="project_id=YOUR_PROJECT" -var="environment=dev"
terraform apply -var="project_id=YOUR_PROJECT" -var="environment=prod"
```

**3. Deploy dev**
```bash
cd terraform/environments/dev
# Edit project_id in terraform.tfvars

terraform init
terraform apply

# Allow public access
gcloud run services add-iam-policy-binding iac-dev-function \
  --region=europe-west1 --member="allUsers" --role="roles/run.invoker"

# Test
curl http://$(terraform output -raw load_balancer_ip)
```

## How CI/CD works

**Dev:** Merge to main → automatic deploy  
**Prod:** Create git tag → manual approval → deploy
```bash
# Deploy to prod
git tag -a v1.0.0 -m "First release"
git push origin v1.0.0
# Go to GitHub Actions, review plan, approve
```

See [docs/deployment.md](docs/deployment.md) for rollback procedures.

## What the function does

- Retrieves a value from Secret Manager
- Lists files in Cloud Storage bucket
- Returns JSON response with both

## Security setup

- Function runs in private VPC
- Zero-trust firewall (deny all, explicit allows)
- Least-privilege IAM
- Workload Identity for CI/CD (no service account keys)
- Daily drift detection to catch manual changes

## Common issues

**403 error:** Missing IAM binding. Run the `gcloud run services add-iam-policy-binding` command above.

**Drift detected:** Check GitHub Issues. Either import changes to Terraform or revert them manually.

**Need rollback:** `./scripts/rollback.sh prod v1.0.0`

## Requirements

- GCP project with billing
- Terraform 1.9.0+
- gcloud CLI