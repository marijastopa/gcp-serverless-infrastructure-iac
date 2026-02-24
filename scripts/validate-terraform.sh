#!/bin/bash

source "$(dirname "$0")/utils/common.sh"

check_terraform

echo "Formatting..."
terraform fmt -recursive terraform/

echo "Validating modules..."
for module in terraform/modules/*; do
    [ -d "$module" ] || continue
    echo "  $(basename $module)"
    (cd "$module" && terraform init -backend=false >/dev/null 2>&1 && terraform validate)
done

echo "Validation complete"