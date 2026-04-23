#!/bin/bash

# Ensure we are in the project root if the script is run from anywhere
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$DIR/../.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

if [ ! -f .env ]; then
  echo ".env file not found!"
  exit 1
fi

# shellcheck disable=SC1091
source .env

if [ -z "$VM_USERNAME" ]; then
  echo "VM_USERNAME is not set in .env! (e.g. yourname)"
  exit 1
fi

if [ -z "$GCP_PROJECT_ID" ]; then
  echo "GCP_PROJECT_ID is not set in .env!"
  exit 1
fi

TF_INSTANCE_NAME=$(cd terraform && terraform output -raw instance_name 2>/dev/null || echo "messenger-agent-bridge-vm")
TF_ZONE=$(cd terraform && terraform output -raw instance_zone 2>/dev/null || echo "us-central1-a")

echo "Establishing SSH tunnel for OpenClaw dashboard (Port 18789)..."
echo "Connecting to VM instance $TF_INSTANCE_NAME in $TF_ZONE..."
echo "Once connected, keep this terminal open. You can access the dashboard at: http://localhost:18789"
echo ""

gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  -- -L 18789:localhost:18789
