#!/usr/bin/env bash

set -e

if [ -z "$TELEGRAM_CODE" ]; then
  echo "Usage: make telegram-approve TELEGRAM_CODE=123456"
  exit 1
fi

echo "Approving Telegram pairing with code: $TELEGRAM_CODE..."

if [ "$LOCAL_DEPLOY" = "true" ]; then
  docker exec openclaw openclaw pairing approve telegram "$TELEGRAM_CODE"
else
  if [ -z "$VM_USERNAME" ]; then
    echo "Ensure VM_USERNAME is set in .env"
    exit 1
  fi
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
    --zone="$TF_ZONE" \
    --project="$GCP_PROJECT_ID" \
    --command="sudo docker exec openclaw openclaw pairing approve telegram $TELEGRAM_CODE"
fi

echo "Pairing complete!"
