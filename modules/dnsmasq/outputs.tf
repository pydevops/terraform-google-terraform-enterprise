output "internal_address" {
  description = "instance internal address."
  value       = google_compute_instance.dnsmasq.network_interface.0.network_ip
}