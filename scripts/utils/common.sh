#!/bin/bash
set -e

check_gcloud() {
    command -v gcloud >/dev/null || { echo "gcloud not installed"; exit 1; }
}

check_terraform() {
    command -v terraform >/dev/null || { echo "terraform not installed"; exit 1; }
}

get_project_id() {
    gcloud config get-value project 2>/dev/null
}