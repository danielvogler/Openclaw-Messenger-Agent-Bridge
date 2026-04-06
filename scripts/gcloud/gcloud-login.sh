#!/usr/bin/env bash
set -e

if [ -z "$GCP_PROJECT_ID" ]; then
  echo "GCP_PROJECT_ID is not set. Please create a .env file based on .env.example"
  exit 1
fi

echo "Logging into Google Cloud..."

# Strip any accidental quotation marks from the .env file variable
CLEAN_PROJECT_ID=$(echo "$GCP_PROJECT_ID" | tr -d '"' | tr -d "'")

gcloud auth login
gcloud auth application-default login
gcloud config set project "$CLEAN_PROJECT_ID"
echo "Successfully authenticated and set project to $CLEAN_PROJECT_ID!"
