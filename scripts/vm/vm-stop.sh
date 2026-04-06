#!/bin/bash
echo "Stopping VM instance $TF_INSTANCE_NAME in $TF_ZONE..."
gcloud compute instances stop "$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID"
