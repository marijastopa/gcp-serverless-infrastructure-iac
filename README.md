# GCP Serverless Infrastructure - IaC

Terraform-based infrastructure for serverless workloads on Google Cloud Platform. Implements private networking, secret management, and enterprise security controls across multiple environments.

## Structure
```
terraform/
 - modules/          # Reusable components
 - environments/     # Dev and prod configs
 - backend-setup/    # State bucket setup
```

## Environments

- **dev**: Development environment
- **prod**: Production environment (manual approval required)

## Architecture

- **Cloud Functions Gen2** - Serverless compute
- **VPC** - Private networking with zero-trust firewall rules
- **Application Load Balancer** - Public endpoint (only public resource)
- **Secret Manager** - Secure secret storage
- **Cloud Storage** - File storage
- **Service Accounts** - Least-privilege IAM
- **Workload Identity Federation** - Keyless CI/CD authentication

All resources except the Load Balancer are deployed in a private network with IAM-based access control.

## Prerequisites

- GCP project with billing enabled
- `gcloud` CLI configured
- Terraform >= 1.9.0
- GitHub repository for CI/CD

## Quick Start

### 1. Enable APIs
```bash
./scripts/enable-apis.sh
```

### 2. Create Terraform State Buckets
```bash
cd terraform/backend-setup
terraform init
terraform apply \
  -var="project_id=PROJECT_ID" \
  -var="environment=dev"
```

### 3. Configure Environment Variables
```bash
cd terraform/environments/dev
terraform.tfvars
```

### 4. Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 5. Add Secret Value
```bash
echo -n "your-secret-value" > /tmp/secret.txt
gcloud secrets versions add iac-dev-app-secret \
  --data-file=/tmp/secret.txt \
  --project=PROJECT_ID
rm /tmp/secret.txt
```

### 6. Add IAM Binding (required for LB access)
```bash
gcloud run services add-iam-policy-binding iac-dev-function \
  --region=europe-west1 \
  --member="allUsers" \
  --role="roles/run.invoker" \
  --project=PROJECT_ID
```

### 7. Test Deployment
```bash
# Get Load Balancer IP from outputs
terraform output load_balancer_url

# Test function
curl http://LOAD_BALANCER_IP
```

Expected response:
```json
{
  "status": "success",
  "secret_access_verified": true,
  "secret_id": "iac-dev-app-secret",
  "bucket": "PROJECT_ID-app-data-dev",
  "files_count": 0,
  "files": []
}
```

## Security Features

- **Zero-trust networking** - Deny-all firewall rules with explicit allows
- **Private networking** - All resources in VPC except Load Balancer
- **Least-privilege IAM** - Function SA has access only to required resources
- **No secrets in code** - Secrets in Secret Manager, not Terraform state
- **Workload Identity** - No service account keys in CI/CD
- **Ingress restrictions** - Function accepts only LB + internal traffic

## CI/CD

GitHub Actions workflows:
- `terraform-plan.yml` - Plan on PR
- `terraform-apply.yml` - Apply on merge to main
- `deploy-secrets.yml` - Secret injection

## Verification

### Infrastructure Setup
```bash
# Check VPC
gcloud compute networks describe iac-dev-vpc --project=PROJECT_ID

# Check firewall rules (should deny all by default)
gcloud compute firewall-rules list --project=PROJECT_ID

# Check function is private
gcloud run services describe iac-dev-function \
  --region=europe-west1 \
  --format="value(spec.template.spec.serviceAccountName,spec.template.spec.containers[0].env)"
```

### Function Verification

The function verifies connectivity to:
- **Secret Manager** - Retrieves secret value (logged in dev, not in response)
- **Cloud Storage** - Lists files in bucket

## Cleanup
```bash
cd terraform/environments/dev
terraform destroy
```

## License

MIT

