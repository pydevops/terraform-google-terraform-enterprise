data "template_file" "startup_script" {
  template = file("${path.module}/startup.sh.tpl")
  vars = {
    domain_name         = var.dnsmasq["domain_name"]
    upstream_dns_server = var.dnsmasq["upstream_dns_server"]
    ip_address          = var.dnsmasq["bitbucket_ip_address"]
  }
}
resource "random_string" "name_suffix" {
  length  = 4
  upper   = false
  special = false
}
resource "google_compute_instance" "dnsmasq" {
  name         = "dnsmasq-${random_string.name_suffix.result}"
  machine_type = "g1-small"
  zone         = var.dnsmasq["zone"]

  boot_disk {
    initialize_params {
      image = var.dnsmasq["disk_source_image"]
    }
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  tags = ["dnsmasq"]

  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  # lifecycle {
  #   create_before_destroy = true
  # }
}