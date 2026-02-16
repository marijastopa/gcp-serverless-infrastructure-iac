#!/bin/bash

source "$(dirname "$0")/utils/common.sh"

check_gcloud

PROJECT_ID=$(get_project_id)

if [ -z "$PROJECT_ID" ]; then
    echo "No GCP project configured. Run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "Using GCP Project: $PROJECT_ID"

BILLING_ENABLED=$(gcloud beta billing projects describe "$PROJECT_ID" --format="value(billingEnabled)" 2>/dev/null || echo "false")

if [ "$BILLING_ENABLED" != "True" ]; then
    echo "Warning: Billing not enabled"
    echo "Enable at: https://console.cloud.google.com/billing/linkedaccount?project=$PROJECT_ID"
    exit 1
fi

echo "Project setup OK"
echo "Next: ./scripts/enable-apis.sh"