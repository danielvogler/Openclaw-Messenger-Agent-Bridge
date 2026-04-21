.PHONY: all help tf-install tf-init tf-plan tf-apply tf-destroy vm-start vm-stop vm-ssh gcloud-install gcloud-login docker-deploy

# Load variables from .env file if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Map env BUCKET_NAME to Terraform's expected variable
export TF_VAR_data_bucket_name ?= $(BUCKET_NAME)

# Dynamically fetch VM details from Terraform output, with fallbacks
TF_INSTANCE_NAME = $(shell cd terraform && terraform output -raw instance_name 2>/dev/null || echo "messenger-agent-bridge-vm")
TF_ZONE = $(shell cd terraform && terraform output -raw instance_zone 2>/dev/null || echo "us-central1-a")
export TF_INSTANCE_NAME
export TF_ZONE

all: help

help:
	@echo "Messenger Agent Bridge Makefile"
	@echo ""
	@echo "--- GCLOUD SETUP ---"
	@echo "  gcloud-install     - Install Google Cloud SDK (gcloud CLI)"
	@echo "  gcloud-login       - Login to GCP and set project from .env file"
	@echo ""
	@echo "--- CODE QUALITY ---"
	@echo "  lint               - Run ShellCheck on all scripts"
	@echo "  fmt                - Format all scripts with shfmt"
	@echo ""
	@echo "--- TERRAFORM CONFIGURATION ---"
	@echo "  tf-install         - Install Terraform on macOS (via brew) or Linux (via apt)"
	@echo "  tf-init            - Initialize Terraform"
	@echo "  tf-fmt             - Format Terraform configuration files"
	@echo "  tf-validate        - Validate Terraform configuration files"
	@echo "  tf-plan            - Generate and show Terraform execution plan"
	@echo "  tf-apply           - Apply Terraform configuration to provision resources"
	@echo "  tf-destroy         - Destroy Terraform-managed infrastructure"
	@echo ""
	@echo "--- VM LIFECYCLE ---"
	@echo "  vm-start           - Start the GCP VM via gcloud"
	@echo "  vm-stop            - Stop the GCP VM via gcloud to save costs"
	@echo "  vm-ssh             - SSH into the VM via gcloud"
	@echo "  gcs-mount          - Mount the GCS data bucket to the VM"
	@echo ""
	@echo "--- OPENCLAW ---"
	@echo "  openclaw-logs      - Fetch OpenClaw container logs"
	@echo "  openclaw-fix-gateway - Approves any pending device or operator requests to unlock AI skills"
	@echo ""
	@echo "--- DEPLOYMENT ---"
	@echo "  docker-deploy      - SCP docker-compose.yml to VM and start containers"
	@echo ""
	@echo "--- SIGNAL REGISTRATION ---"
	@echo "  signal-register    - Request SMS code for your Signal number"
	@echo "  signal-verify      - Verify Signal SMS code (requires CODE=...)"
	@echo "  signal-test-message- Send a test message from your Bot to Owner"
	@echo "  signal-set-profile - Set the Signal Bot's display name"
	@echo "  signal-pair        - Initiate OpenClaw pairing for your Signal number"
	@echo "  signal-pair-list   - List pending OpenClaw pairing requests"
	@echo "  signal-pair-approve- Approve an OpenClaw pairing request (requires CODE=...)"
	@echo ""
	@echo "--- TELEGRAM REGISTRATION ---"
	@echo "  telegram-pair      - List pending Telegram pairing requests"
	@echo "  telegram-approve   - Approve a Telegram pairing request (requires TELEGRAM_CODE=...)"
	@echo ""

# ==========================================
# CODE QUALITY
# ==========================================

lint:
	@echo "Running ShellCheck on scripts..."
	@shellcheck scripts/*/*.sh
	@echo "All scripts passed!"

fmt:
	@echo "Formatting scripts with shfmt..."
	@shfmt -i 2 -ci -w scripts/*/*.sh
	@echo "Formatting complete!"

# ==========================================
# GCLOUD SECTION
# ==========================================

gcloud-install:
	@./scripts/gcloud/gcloud-install.sh

gcloud-login:
	@./scripts/gcloud/gcloud-login.sh

# ==========================================
# TERRAFORM SECTION
# ==========================================

tf-install:
	@./scripts/terraform/tf-install.sh

tf-init:
	@cd terraform && terraform init

tf-fmt:
	@cd terraform && terraform fmt

tf-validate: tf-init
	@cd terraform && terraform validate

tf-plan: tf-init
	@cd terraform && terraform plan

tf-apply: tf-init
	@cd terraform && terraform apply

tf-destroy:
	@cd terraform && terraform destroy

# ==========================================
# VM LIFECYCLE SECTION
# ==========================================

vm-start:
	@./scripts/vm/vm-start.sh

vm-stop:
	@./scripts/vm/vm-stop.sh

vm-ssh:
	@./scripts/vm/vm-ssh.sh

gcs-mount:
	@./scripts/gcs/gcs-mount.sh

# ==========================================
# DOCKER DEPLOYMENT SECTION
# ==========================================

docker-deploy:
	@./scripts/docker/docker-deploy.sh

# ==========================================
# OPENCLAW SECTION
# ==========================================

openclaw-logs:
	@./scripts/openclaw/openclaw-logs.sh

openclaw-fix-gateway:
	@./scripts/openclaw/openclaw-fix-gateway.sh

# ==========================================
# SIGNAL REGISTRATION SECTION
# ==========================================

signal-register:
	@./scripts/signal/signal-register.sh

signal-register-voice:
	@./scripts/signal/signal-register-voice.sh

signal-verify:
	@./scripts/signal/signal-verify.sh

signal-test-message:
	@./scripts/signal/signal-test-message.sh

signal-submit-challenge:
	@./scripts/signal/signal-submit-challenge.sh

signal-set-profile:
	@./scripts/signal/signal-set-profile.sh

signal-pair:
	@./scripts/signal/signal-pair.sh

signal-pair-list:
	@./scripts/signal/signal-pair-list.sh

signal-pair-approve:
	@./scripts/signal/signal-pair-approve.sh

# ==========================================
# TELEGRAM REGISTRATION SECTION
# ==========================================

telegram-pair:
	@./scripts/telegram/telegram-pair.sh

telegram-approve:
	@./scripts/telegram/telegram-approve.sh
