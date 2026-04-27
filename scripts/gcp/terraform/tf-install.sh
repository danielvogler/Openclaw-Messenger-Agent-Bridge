#!/usr/bin/env bash
set -e

echo "Installing Terraform..."
if [ "$(uname)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Please install Homebrew first."
    exit 1
  fi
  echo "Detected macOS, using Homebrew..."
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
elif [ "$(uname)" = "Linux" ]; then
  echo "Detected Linux, using apt..."
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install terraform
else
  echo "Unsupported OS for automatic installation. Please install Terraform manually."
  echo "Visit: https://developer.hashicorp.com/terraform/downloads"
  exit 1
fi
echo "Terraform installation complete!"
