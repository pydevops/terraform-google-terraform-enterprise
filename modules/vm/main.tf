resource "google_compute_instance_template" "main" {
  name_prefix  = "${var.namespace}-tfe-template-"
  machine_type = var.machine_type

  disk {
    source_image = var.disk_source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    mode         = "READ_WRITE"
    type         = "PERSISTENT"
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  metadata_startup_script = var.metadata_startup_script

  service_account {
    scopes = ["cloud-platform"]

    email = var.service_account
  }

  labels = var.labels

  can_ip_forward       = true
  description          = "The instance template of the compute deployment for TFE."
  instance_description = "An instance of the compute deployment for TFE."

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  standalone_named_ports = toset(
    [
      {
        name = "https"
        port = 443
      },
      {
        name = "console"
        port = 8800
      }
    ]
  )
  active_active_named_ports = toset(
    [
      {
        name = "https"
        port = 443
      },
    ]
  )
  named_ports = var.active_active ? local.active_active_named_ports : local.standalone_named_ports
}

resource "google_compute_region_instance_group_manager" "main" {
  name = "${var.namespace}-tfe-group-manager"

  base_instance_name = "${var.namespace}-tfe-vm"

  version {
    instance_template = google_compute_instance_template.main.self_link
  }

  target_size = var.node_count

  dynamic "named_port" {
    for_each = local.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_enabled ? ["one"] : []
    content {
      health_check      = google_compute_health_check.tfe_instance_health.self_link
      initial_delay_sec = 600
    }
  }
}

resource "google_compute_health_check" "tfe_instance_health" {
  name                = "${var.namespace}-tfe-health-check"
  check_interval_sec  = 60
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 6

  https_health_check {
    port         = 443
    request_path = "/_health_check"
  }
}
