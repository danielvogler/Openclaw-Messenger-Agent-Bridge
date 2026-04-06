#!/bin/bash
if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$CODE" ] || [ -z "$VM_USERNAME" ]; then
  echo "Usage: make signal-verify CODE=123456 (Make sure BOT_PHONE_NUMBER is in .env)"
  exit 1
fi
echo "Verifying Signal SMS code $CODE for $BOT_PHONE_NUMBER..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="curl -X POST -H 'Content-Type: application/json' -d '{\"pin\":\"$CODE\"}' http://localhost:8080/v1/register/$BOT_PHONE_NUMBER/verify/$CODE"
