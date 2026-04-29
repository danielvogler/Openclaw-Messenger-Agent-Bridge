# Local Deployment Plan on Mac Mini

This document outlines the plan to adapt the existing cloud-based containerized setup of Openclaw-Messenger-Agent-Bridge to run locally on your Mac Mini.

## Review of Current Setup
The current repository is heavily tailored for deploying to a Google Cloud Platform (GCP) Virtual Machine. It relies on:
1. **Terraform**: To provision the GCP VM and Google Cloud Storage (GCS) buckets.
2. **Bash Scripts**: To interact with GCP (`gcloud` CLI), handle VM lifecycles (start, stop, ssh), and copy deployment files via SCP.
3. **Docker Compose**: Uses an absolute path structure (`/home/$VM_USERNAME/...`) suited for the linux VM.
4. **Makefile**: Wraps all the terraform and `gcloud` logic into easy-to-use commands.

## Necessary Components for Local Mac Mini Deployment
To run this locally, we can reuse the core containerized elements and strip away the cloud infrastructure wrapper:

1. **`docker/openclaw/` directory**: The Dockerfile, `openclaw.config.json5`, and `soul.yaml` are perfectly reusable.
2. **`.env` file**: You will still need an environment file to pass API keys, Telegram tokens, and Phone Numbers.
3. **Signal/Telegram Scripts**: Scripts like `signal-register`, `signal-verify`, etc. that interact with the Signal API or Telegram API remain relevant, provided they point to your local localhost instead of a remote VM IP.

## Plan to Adapt for Mac Mini

1. **Refactor Docker Compose with Overrides**:
   - Move the base configuration (images, build contexts, environment variables, ports) into a core `docker/docker-compose.yml`.
   - Create `docker/docker-compose.gcp.yml` containing only the GCP-specific volume mappings (`/home/${VM_USERNAME}/...`).
   - Create `docker/docker-compose.local.yml` containing local relative volume mappings (e.g., `./data/messenger-data:/home/...`).
   - When deploying, we will run `docker compose -f docker-compose.yml -f docker-compose.local.yml up` for local, and use `-f docker-compose.gcp.yml` for the cloud VM.
   - This prevents duplicating the large environment variables block and keeps the core setup DRY (Don't Repeat Yourself).

2. **Update Local Data Storage**:
   - Create a `data/` directory in the root of the repo (and add it to `.gitignore`) to hold your local `messenger-data` and `openclaw-data`.

3. **Create Local Deployment Scripts**:
   - Create a simple script (e.g., `scripts/local/deploy.sh`) or a Makefile target (e.g., `make local-deploy`) that simply runs `docker compose -f docker/docker-compose.local.yml up -d --build`. This replaces the complex `docker-deploy.sh` that used SCP.

4. **Adjust Signal CLI Scripts**:
   - Ensure the `scripts/signal/*.sh` scripts point to `localhost:8080` instead of relying on a remote connection. Currently they seem to use curl; we need to verify if they depend on an external IP or just localhost.

## Scope of Changes

To be completely clear, **the only files that will be modified or created are:**
- `docker/docker-compose.yml` (modified to be base)
- `docker/docker-compose.gcp.yml` (new)
- `docker/docker-compose.local.yml` (new)
- `Makefile` (modified to add local targets and update gcp targets)
- `scripts/docker/docker-deploy.sh` (modified to use the new base + gcp compose structure)
- `scripts/local/deploy.sh` (new)

Your Openclaw agent configuration (`soul.yaml`, `openclaw.config.json5`, `Dockerfile`) and the Terraform infrastructure will remain entirely untouched.

## Addressing the Clutter: Same Repo or New Repo?

**Recommendation: Keep it in the SAME repository.**

While it might seem like there is "clutter" due to the Terraform and GCP scripts, it is a very common industry practice to have a single repository that supports multiple deployment environments (e.g., Local, Staging, Production Cloud).

**How to avoid clutter:**
1. Keep the cloud scripts in `scripts/gcp/` (most are already nicely organized).
2. Create a `scripts/local/` folder for your Mac Mini specific startup scripts.
3. Use Docker Compose overrides (`docker-compose.local.yml` and `docker-compose.gcp.yml`) alongside the base `docker-compose.yml`.
4. Add a `# LOCAL MAC DEPLOYMENT` section to the `Makefile`.

By structuring it this way, you maintain one single source of truth for the `openclaw/Dockerfile` and configuration, meaning if you update your Openclaw agent's prompt or soul, you don't have to copy it between a "local repo" and a "cloud repo". 

## User Review Required

> [!IMPORTANT]
> **Action Needed:** Please review this plan. 
> 
> 1. Your suggestion to use a base compose file with local/gcp overrides is excellent and is now the planned approach. Do you approve moving forward with this?
> 2. Will you still be using Google Vertex AI from your local Mac Mini, or will you be switching to standard OpenAI/Anthropic/Gemini APIs directly? (If not using Vertex, we can just omit those variables from the `.env` locally).
> 
> Once approved, I can execute these changes.
