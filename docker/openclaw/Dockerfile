FROM ghcr.io/openclaw/openclaw:latest

# Switch to root to install system packages
USER root

# Install common utilities for AI agents
RUN apt-get update && \
    apt-get install -y \
      python3 \
      python3-pip \
      python3-venv \
      git \
      curl \
      wget \
      jq \
      unzip \
      zip \
      tar \
      chromium \
      chromium-driver && \
    rm -rf /var/lib/apt/lists/*

# Set up a global virtual environment that the 'node' user owns
RUN python3 -m venv /opt/venv && \
    chown -R node:node /opt/venv && \
    ln -sf /opt/venv/bin/python3 /usr/local/bin/python3 && \
    ln -sf /opt/venv/bin/python /usr/local/bin/python && \
    ln -sf /opt/venv/bin/pip3 /usr/local/bin/pip3 && \
    ln -sf /opt/venv/bin/pip /usr/local/bin/pip

# Pre-install yt-dlp globally using pip so it's always available
RUN /opt/venv/bin/pip install --no-cache-dir yt-dlp && \
    ln -sf /opt/venv/bin/yt-dlp /usr/local/bin/yt-dlp

# Activate the virtual environment permanently in the container
ENV PATH="/opt/venv/bin:$PATH"

# Switch back to the non-root user (OpenClaw uses 'node' user)
USER node

# Create the data directory
RUN mkdir -p /app/config

# Copy the specialized soul configuration
COPY soul.yaml /app/config/soul.yaml

# Point OpenClaw to use this soul configuration
ENV OPENCLAW_SOUL_PATH=/app/config/soul.yaml
