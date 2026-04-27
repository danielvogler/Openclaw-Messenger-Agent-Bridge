#!/bin/bash
echo "Fetching OpenClaw Logs..."

if [ "$LOCAL_DEPLOY" = "true" ]; then
  docker logs openclaw
else
  if [ -z "$VM_USERNAME" ]; then
    echo "Ensure VM_USERNAME is set in .env"
    exit 1
  fi
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker logs openclaw"
fi
