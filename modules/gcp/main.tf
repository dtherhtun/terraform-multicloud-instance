locals {
  services = ["compute.googleapis.com"]
}

resource "google_project_service" "enabled_service" {
  for_each = toset(local.services)
  project  = var.project_id
  service  = each.key
  provisioner "local-exec" {
    command = "sleep 60"
  }
  disable_on_destroy = false
}

resource "google_compute_firewall" "default" {
  depends_on = [google_project_service.enabled_service["compute.googleapis.com"]]
  name       = "default-firewall"
  network    = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "compute_instance" {
  depends_on   = [google_project_service.enabled_service["compute.googleapis.com"]]
  name         = "gcp-vm"
  machine_type = "n1-standard-1"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh", { NAME = var.environment.name, BG_COLOR = var.environment.background_color })

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
