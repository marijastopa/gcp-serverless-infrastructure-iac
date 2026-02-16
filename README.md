# GCP Serverless Infrastructure - IaC

Terraform-based infrastructure for serverless workloads on Google Cloud Platform. Implements private networking, secret management, and enterprise security controls across multiple environments.

## Architecture

- **VPC**: Custom network with private subnets and Cloud NAT
- **Cloud Functions**: Gen 2 functions with VPC connectivity
- **Secret Manager**: Centralized secret storage with IAM controls
- **Cloud Storage**: Private bucket with lifecycle policies
- **Load Balancer**: HTTPS Application LB with serverless backend
- **Security**: Zero public exposure except LB endpoint, least-privilege IAM

## Prerequisites

- GCP Project with billing enabled
- Terraform >= 1.9.0
- gcloud CLI authenticated
- Required GCP APIs enabled`

## Security Controls

- Private VPC with no default internet access
- Cloud NAT for controlled egress
- Service accounts with least-privilege IAM
- Secret Manager for credential storage
- VPC Service Controls
- Cloud Armor