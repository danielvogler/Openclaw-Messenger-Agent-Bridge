#!/bin/bash
if [ -z "$CODE" ] || [ -z "$VM_USERNAME" ]; then
  echo "Usage: make signal-pair-approve CODE=<PAIRING_CODE>"
  exit 1
fi
echo "Approving OpenClaw pairing code $CODE..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker exec openclaw openclaw pairing approve signal $CODE"
echo "Pairing approved! You can now chat with your Agent via Signal."
