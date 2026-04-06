#!/bin/bash
if [ -z "$OWNER_PHONE_NUMBER" ] || [ -z "$VM_USERNAME" ]; then
  echo "Ensure OWNER_PHONE_NUMBER and VM_USERNAME are set in .env"
  exit 1
fi
echo "Pairing OpenClaw with OWNER_PHONE_NUMBER: $OWNER_PHONE_NUMBER..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker exec openclaw openclaw pairing list telegram"
echo "Pairing complete!"
