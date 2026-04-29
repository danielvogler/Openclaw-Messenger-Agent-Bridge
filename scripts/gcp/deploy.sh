#!/usr/bin/env bash

set -e

if [ -z "$OWNER_PHONE_NUMBER" ] || [ -z "$VM_USERNAME" ]; then
  echo "Ensure OWNER_PHONE_NUMBER and VM_USERNAME are set in .env!"
  exit 1
fi

echo "Deploying docker-compose.yml and configs to VM instance $TF_INSTANCE_NAME..."

gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="mkdir -p /home/$VM_USERNAME/openclaw /home/$VM_USERNAME/openclaw-data /home/$VM_USERNAME/messenger-data"

echo "Ensuring user has write permissions for SCP..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="sudo chown -R $VM_USERNAME:$VM_USERNAME /home/$VM_USERNAME/openclaw || true"

gcloud compute scp --recurse docker/openclaw/* "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/openclaw/" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

echo "Setting explicit permissions so Docker user (1000) can read/write data persistently..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="sudo chown -R 1000:1000 /home/$VM_USERNAME/messenger-data /home/$VM_USERNAME/openclaw-data /home/$VM_USERNAME/openclaw && sudo chmod -R 777 /home/$VM_USERNAME/messenger-data /home/$VM_USERNAME/openclaw-data /home/$VM_USERNAME/openclaw"

gcloud compute scp docker/docker-compose.yml docker/docker-compose.gcp.yml "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

gcloud compute scp .env "$VM_USERNAME@$TF_INSTANCE_NAME:/home/$VM_USERNAME/.env" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID"

echo "Starting Docker Compose on VM in home directory..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" \
  --zone="$TF_ZONE" \
  --project="$GCP_PROJECT_ID" \
  --command="cd /home/$VM_USERNAME && sudo BOT_PHONE_NUMBER=$BOT_PHONE_NUMBER OWNER_PHONE_NUMBER=$OWNER_PHONE_NUMBER GCP_PROJECT_ID=$GCP_PROJECT_ID docker compose -f docker-compose.yml -f docker-compose.gcp.yml up -d --build"

echo "Successfully deployed and started AgentBridge & OpenClaw on VM!"
