#!/bin/bash

source "$(dirname "$0")/utils/common.sh"

check_gcloud

ENV=${1:-dev}
[[ ! "$ENV" =~ ^(dev|prod)$ ]] && { echo "Usage: $0 <dev|prod>"; exit 1; }

PROJECT_ID=$(get_project_id)
[ -z "$PROJECT_ID" ] && { echo "No project configured"; exit 1; }

BUCKET_NAME="${PROJECT_ID}-tfstate-${ENV}"
REGION="europe-west1"

echo "Creating state bucket: $BUCKET_NAME"

if gsutil ls -b "gs://${BUCKET_NAME}" &> /dev/null; then
    echo "Bucket exists, skipping creation"
else
    gsutil mb -p "$PROJECT_ID" -l "$REGION" "gs://${BUCKET_NAME}"
    gsutil versioning set on "gs://${BUCKET_NAME}"
    gsutil uniformbucketlevelaccess set on "gs://${BUCKET_NAME}"
    echo "Bucket created"
fi

echo "Update backend.tf with bucket: $BUCKET_NAME"