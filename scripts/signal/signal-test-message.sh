#!/bin/bash
if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$OWNER_PHONE_NUMBER" ] || [ -z "$VM_USERNAME" ]; then
  echo "Ensure BOT_PHONE_NUMBER, OWNER_PHONE_NUMBER, and VM_USERNAME are set in .env"
  exit 1
fi
echo "Sending test message from $BOT_PHONE_NUMBER to $OWNER_PHONE_NUMBER..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="curl -X POST -H 'Content-Type: application/json' -d '{\"message\": \"Hello! I am alive and fully registered!\", \"number\": \"$BOT_PHONE_NUMBER\", \"recipients\": [ \"$OWNER_PHONE_NUMBER\" ]}' http://localhost:8080/v2/send"
