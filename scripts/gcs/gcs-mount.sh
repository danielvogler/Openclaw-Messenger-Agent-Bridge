#!/bin/bash
if [ -z "$VM_USERNAME" ]; then
  echo "VM_USERNAME is not set in .env! (e.g. yourname)"
  exit 1
fi

BUCKET_NAME=$(cd terraform && terraform output -raw data_bucket_name 2>/dev/null || echo "messenger-agent-data-bucket-${GCP_PROJECT_ID}")

echo "Mounting GCS bucket $BUCKET_NAME on VM $TF_INSTANCE_NAME..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" <<EOF
  mkdir -p ~/gcs-data
  # Check if already mounted
  if mountpoint -q ~/gcs-data; then
    echo "GCS bucket is already mounted."
  else
    echo "Mounting bucket..."
    # Ensure fuse allows other users to access the mount
    sudo bash -c 'grep -q "^user_allow_other" /etc/fuse.conf || echo "user_allow_other" >> /etc/fuse.conf'
    gcsfuse -o allow_other --file-mode=0777 --dir-mode=0777 --implicit-dirs $BUCKET_NAME ~/gcs-data
  fi
EOF
