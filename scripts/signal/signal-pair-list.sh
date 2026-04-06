#!/bin/bash
if [ -z "$VM_USERNAME" ]; then
  echo "Ensure VM_USERNAME is set in .env"
  exit 1
fi
echo "Checking for pending OpenClaw pairing requests..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker exec openclaw openclaw pairing list signal"
