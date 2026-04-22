#!/bin/bash
set -e

# Update and install dependencies
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install gcsfuse
GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)"
export GCSFUSE_REPO
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gcsfuse

# Allow other users (like Docker) to access FUSE mounts
echo "user_allow_other" >> /etc/fuse.conf

systemctl enable docker
systemctl start docker


