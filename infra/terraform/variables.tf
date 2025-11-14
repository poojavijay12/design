variable "gcp_project" {
  description = "pooja3134"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}


variable "machine_type" {
  description = "Compute instance machine type"
  type        = string
  default     = "e2-medium"
}

variable "image_family" {
  description = "Boot disk image family"
  type        = string
  default     = "debian-12"
}

variable "image_project" {
  description = "Image project for boot disk"
  type        = string
  default     = "debian-cloud"
}

variable "container_image" {
  description = "Container image to run on the VM (Artifact Registry/GCR full path)"
  type        = string
}
