#!/bin/bash
echo "Starting VM instance $TF_INSTANCE_NAME in $TF_ZONE..."
gcloud compute instances start "$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID"
echo "Waiting for SSH to become available..."
until gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="exit" >/dev/null 2>&1; do
  echo "Instance is booting, retrying in 5s..."
  sleep 5
done
echo "VM is UP and SSH is ready."
