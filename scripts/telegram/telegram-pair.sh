#!/bin/bash
if [ -z "$OWNER_PHONE_NUMBER" ]; then
  echo "Ensure OWNER_PHONE_NUMBER is set in .env"
  exit 1
fi
echo "Pairing OpenClaw with OWNER_PHONE_NUMBER: $OWNER_PHONE_NUMBER..."

if [ "$LOCAL_DEPLOY" = "true" ]; then
  docker exec openclaw openclaw pairing list telegram
else
  if [ -z "$VM_USERNAME" ]; then
    echo "Ensure VM_USERNAME is set in .env for remote deploy"
    exit 1
  fi
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker exec openclaw openclaw pairing list telegram"
fi

echo "Pairing complete!"
