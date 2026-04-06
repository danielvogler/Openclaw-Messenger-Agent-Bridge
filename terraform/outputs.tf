output "instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.messenger_bridge.name
}

output "instance_zone" {
  description = "The zone of the VM instance"
  value       = google_compute_instance.messenger_bridge.zone
}

output "instance_public_ip" {
  description = "The public IP address of the VM"
  value       = google_compute_instance.messenger_bridge.network_interface.0.access_config.0.nat_ip
}

output "instance_internal_ip" {
  description = "The internal IP address of the VM"
  value       = google_compute_instance.messenger_bridge.network_interface.0.network_ip
}
