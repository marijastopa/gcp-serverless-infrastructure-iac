#!/bin/bash

source "$(dirname "$0")/utils/common.sh"

ENV=${1:-dev}

echo "WARNING: This destroys all infrastructure in $ENV"
read -p "Continue? (yes/no): " confirm
[ "$confirm" != "yes" ] && exit 0

cd "terraform/environments/${ENV}"
terraform destroy

echo "Destroyed"