#!/bin/bash

source "$(dirname "$0")/utils/common.sh"

check_gcloud

PROJECT_ID=$(get_project_id)
[ -z "$PROJECT_ID" ] && { echo "No project configured"; exit 1; }

echo "Enabling APIs for: $PROJECT_ID"

APIS=(
    "compute.googleapis.com"
    "cloudfunctions.googleapis.com"
    "cloudbuild.googleapis.com"
    "run.googleapis.com"
    "storage.googleapis.com"
    "secretmanager.googleapis.com"
    "vpcaccess.googleapis.com"
    "servicenetworking.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "iam.googleapis.com"
    "gcloud services enable cloudresourcemanager.googleapis.com"
)

for api in "${APIS[@]}"; do
    echo "Enabling $api..."
    gcloud services enable "$api" --project="$PROJECT_ID"
done

echo "Done"
echo "Next: ./scripts/create-terraform-backend.sh dev"