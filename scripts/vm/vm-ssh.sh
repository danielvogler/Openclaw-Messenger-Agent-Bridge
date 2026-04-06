#!/bin/bash
if [ -z "$VM_USERNAME" ]; then
  echo "VM_USERNAME is not set in .env! (e.g. yourname)"
  exit 1
fi
echo "Connecting to VM instance $TF_INSTANCE_NAME in $TF_ZONE..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID"
