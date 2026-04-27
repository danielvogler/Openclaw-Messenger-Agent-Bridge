#!/usr/bin/env bash

set -e

echo "Checking for pending device or operator requests..."

if [ "$LOCAL_DEPLOY" = "true" ]; then
  docker exec openclaw openclaw devices list
  echo "Approving the latest pairing request to restore access..."
  docker exec openclaw openclaw devices approve --latest
else
  if [ -z "$VM_USERNAME" ]; then
    echo "Ensure VM_USERNAME is set in .env"
    exit 1
  fi
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
    --zone="$TF_ZONE" \
    --project="$GCP_PROJECT_ID" \
    --command="sudo docker exec openclaw openclaw devices list"

  echo "Approving the latest pairing request to restore access..."
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
    --zone="$TF_ZONE" \
    --project="$GCP_PROJECT_ID" \
    --command="sudo docker exec openclaw openclaw devices approve --latest"
fi

echo "Access restored. Tell the bot to try the command again."
