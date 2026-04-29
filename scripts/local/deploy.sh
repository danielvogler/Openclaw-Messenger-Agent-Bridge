#!/usr/bin/env bash

set -e

# Load variables from .env if it exists
if [ -f ".env" ]; then
  # shellcheck disable=SC1091
  source .env
fi

if [ -z "$BOT_PHONE_NUMBER" ] || [ -z "$OWNER_PHONE_NUMBER" ]; then
  echo "Ensure BOT_PHONE_NUMBER and OWNER_PHONE_NUMBER are set in .env!"
  exit 1
fi

# Default to ~/.openclaw-local-data if not specified in .env
LOCAL_DATA_DIR=${LOCAL_DATA_DIR:-~/.openclaw-local-data}
export LOCAL_DATA_DIR

echo "Creating local data directories at $LOCAL_DATA_DIR..."
mkdir -p "$LOCAL_DATA_DIR/messenger-data" "$LOCAL_DATA_DIR/openclaw-data" "$LOCAL_DATA_DIR/gcs-data" "$LOCAL_DATA_DIR/openclaw"

# Copy the initial config files if they don't already exist in the target folder
if [ ! -f "$LOCAL_DATA_DIR/openclaw/openclaw.config.json5" ]; then
  echo "Copying default OpenClaw configurations to $LOCAL_DATA_DIR/openclaw..."
  cp -R docker/openclaw/* "$LOCAL_DATA_DIR/openclaw/"
fi

echo "Deploying OpenClaw Agent locally..."
docker compose --env-file .env -f docker/docker-compose.yml -f docker/docker-compose.local.yml up -d --build

echo "Successfully started OpenClaw and Signal API locally!"
echo "Check logs with: docker compose -f docker/docker-compose.yml -f docker/docker-compose.local.yml logs -f"
