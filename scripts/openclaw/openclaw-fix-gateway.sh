#!/usr/bin/env bash

set -e

if [ -z "$VM_USERNAME" ]; then
  echo "Ensure VM_USERNAME is set in .env"
  exit 1
fi

echo "Checking for pending device or operator requests..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="sudo docker exec openclaw openclaw devices list"

echo "Approving the latest pairing request to restore access..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="sudo docker exec openclaw openclaw devices approve --latest"

echo "Access restored. Tell the bot to try the command again."
