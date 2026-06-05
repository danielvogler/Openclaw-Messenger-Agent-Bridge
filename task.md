# Task Checklist: Mac Mini Local Deployment

- `[/]` Refactor Docker Compose Configuration
  - `[ ]` Modify `docker/docker-compose.yml` to act as the base configuration (remove volume mappings).
  - `[ ]` Create `docker/docker-compose.gcp.yml` for GCP specific volume mounts.
  - `[ ]` Create `docker/docker-compose.local.yml` for local specific relative volume mounts.
- `[ ]` Update Deployment Scripts
  - `[ ]` Create `scripts/local/deploy.sh` for local deployment.
  - `[ ]` Modify `scripts/docker/docker-deploy.sh` to use base + gcp compose overrides.
- `[ ]` Update Makefile
  - `[ ]` Add `# LOCAL MAC DEPLOYMENT` section and targets.
  - `[ ]` Update GCP docker deploy target if necessary.
- `[ ]` Create `.gitignore` entry for local `data/` folder.
- `[ ]` Verification
