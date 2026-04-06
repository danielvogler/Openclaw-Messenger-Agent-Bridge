#!/bin/bash
if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$BOT_NAME" ] || [ -z "$VM_USERNAME" ]; then
  echo "Ensure BOT_PHONE_NUMBER, BOT_NAME, and VM_USERNAME are set in .env"
  exit 1
fi
echo "Setting Signal Profile Name to $BOT_NAME..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="curl -X PUT -H 'Content-Type: application/json' -d '{\"name\": \"$BOT_NAME\"}' http://localhost:8080/v1/profiles/$BOT_PHONE_NUMBER"
