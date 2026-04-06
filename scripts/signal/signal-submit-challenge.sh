#!/bin/bash
if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$CHALLENGE" ] || [ -z "$CAPTCHA" ] || [ -z "$VM_USERNAME" ]; then
  echo "Usage: make signal-submit-challenge CHALLENGE=... CAPTCHA=..."
  exit 1
fi
echo "Submitting Signal Rate Limit Challenge..."
gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="sudo docker exec signal-api signal-cli --config /home/.local/share/signal-cli -a $BOT_PHONE_NUMBER submitRateLimitChallenge --challenge $CHALLENGE --captcha '$CAPTCHA'"
