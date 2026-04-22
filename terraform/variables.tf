variable "project_id" {
  description = "The GCP project ID where resources will be deployed"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
  default     = "messenger-agent-bridge-vm"
}

variable "machine_type" {
  description = "The machine type for the VM (e2-micro or e2-medium)"
  type        = string
  default     = "e2-medium"
}

variable "data_bucket_name" {
  description = "Name of the GCS bucket for big data storage"
  type        = string
  default     = "messenger-agent-data-bucket"
}
