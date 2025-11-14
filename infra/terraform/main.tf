locals {
  vm_name = "fastapi-vm"
}

resource "google_compute_network" "vpc" {
  name = "fastapi-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "fastapi-subnet"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = local.vm_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    container-image = var.container_image
  }

  metadata_startup_script = file("${path.module}/../scripts/startup.sh")

  tags = ["http-server"]
}

data "google_compute_image" "image" {
  family  = var.image_family
  project = var.image_project
}
