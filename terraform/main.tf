provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Dedicated Service Account for the Bot
resource "google_service_account" "bot_sa" {
  account_id   = "messenger-bot-sa"
  display_name = "Messenger Agent Bridge Service Account"
  description  = "Dedicated SA for the Signal bot to access Vertex AI Agent Engine securely"
}

# Grant Vertex AI User role to the bot Service Account
resource "google_project_iam_member" "bot_sa_vertex_ai" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.bot_sa.email}"
}

# Create a GCS bucket for big data
resource "google_storage_bucket" "data_bucket" {
  name          = var.data_bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Grant Storage Object Admin role to the bot Service Account
resource "google_storage_bucket_iam_member" "bot_sa_storage_admin" {
  bucket = google_storage_bucket.data_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.bot_sa.email}"
}

resource "google_compute_instance" "messenger_bridge" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      # Prefer 24.04 LTS (Ubuntu) as requested
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP required for egress
    }
  }

  metadata_startup_script = file("${path.module}/../scripts/startup.sh")

  tags = ["messenger-bridge", "allow-internal-8080"]

  service_account {
    # Attach the dedicated least-privilege service account
    email  = google_service_account.bot_sa.email
    scopes = ["cloud-platform"]
  }
}

# Firewall rule: internal 8080
resource "google_compute_firewall" "allow_internal_8080" {
  name    = "allow-messenger-bridge-8080"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  # Replace this with your specific VPC internal range or specific IPs
  source_ranges = ["10.128.0.0/9"]
  target_tags   = ["allow-internal-8080"]
}
