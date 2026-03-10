#!/bin/bash
set -e

ENVIRONMENT=$1
VERSION=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/rollback.sh <dev|prod> <git-tag>"
  echo "Example: ./scripts/rollback.sh prod v1.0.0"
  exit 1
fi

echo "Rolling back $ENVIRONMENT to $VERSION..."

git checkout $VERSION
cd terraform/environments/$ENVIRONMENT
terraform init
terraform plan
read -p "Apply rollback? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
  terraform apply
  echo "Rollback complete"
else
  echo "Rollback cancelled"
fi
