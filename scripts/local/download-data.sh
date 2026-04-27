#!/usr/bin/env bash

set -e

if [ -f ".env" ]; then
  # shellcheck disable=SC1091
  source .env
fi

if [ -z "$VM_USERNAME" ] || [ -z "$GCP_PROJECT_ID" ]; then
  echo "Ensure VM_USERNAME and GCP_PROJECT_ID are set in .env"
  exit 1
fi

TF_INSTANCE_NAME=${TF_INSTANCE_NAME:-${GCP_VM_NAME:-agent-bridge-vm}}
TF_ZONE=${TF_ZONE:-$GCP_ZONE}

echo "Adjusting permissions on VM for download..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="sudo chmod -R 755 /home/$VM_USERNAME/messenger-data /home/$VM_USERNAME/openclaw-data /home/$VM_USERNAME/openclaw"

echo "Downloading data from GCP VM to local Mac..."
mkdir -p ~/.openclaw-local-data

gcloud compute scp --recurse "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/messenger-data" ~/.openclaw-local-data/ \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

gcloud compute scp --recurse "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/openclaw-data" ~/.openclaw-local-data/ \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

gcloud compute scp --recurse "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/openclaw" ~/.openclaw-local-data/ \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

echo "Download complete!"
