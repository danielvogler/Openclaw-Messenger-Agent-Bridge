#!/bin/bash
if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$VM_USERNAME" ]; then
  echo "Ensure BOT_PHONE_NUMBER and VM_USERNAME are set in .env"
  exit 1
fi
if [ -n "$CAPTCHA" ]; then
  echo "Requesting Signal SMS with Captcha for $BOT_PHONE_NUMBER..."
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="curl -X POST -H 'Content-Type: application/json' -d '{\"use_voice\": false, \"captcha\": \"$CAPTCHA\"}' http://localhost:8080/v1/register/$BOT_PHONE_NUMBER"
else
  echo "Requesting Signal SMS verification code for $BOT_PHONE_NUMBER..."
  gcloud compute ssh "$VM_USERNAME@$TF_INSTANCE_NAME" --zone="$TF_ZONE" --project="$GCP_PROJECT_ID" --command="curl -X POST -H 'Content-Type: application/json' -d '{\"use_voice\": false}' http://localhost:8080/v1/register/$BOT_PHONE_NUMBER"
fi
