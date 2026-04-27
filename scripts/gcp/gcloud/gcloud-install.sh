#!/usr/bin/env bash
set -e

echo "Installing Google Cloud SDK..."
if [ "$(uname)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Please install Homebrew first."
    exit 1
  fi
  echo "Detected macOS, using Homebrew..."
  brew install --cask google-cloud-sdk
elif [ "$(uname)" = "Linux" ]; then
  echo "Detected Linux, using apt..."
  sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get update && sudo apt-get install -y google-cloud-cli
else
  echo "Unsupported OS for automatic installation. Please install gcloud manually."
  echo "Visit: https://cloud.google.com/sdk/docs/install"
  exit 1
fi
echo "Google Cloud SDK installation complete!"
