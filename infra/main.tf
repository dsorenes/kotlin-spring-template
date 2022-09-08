terraform {
  required_providers {
    google = {
      version = "~> 4.0.0"
    }
  }

  backend "gcs" {
    bucket = "daniel-tf-state"
    prefix = "dev/terraform/state"
  }
}

provider "google" {
  project = var.project-id
  region  = "eu-north1"
}

provider "google-beta" {
  project = var.project-id
  region  = "eu-north1"
}

resource "google_project_service" "artifact-registry" {
  service = "artifactregistry.googleapis.com"
}

resource "google_project_iam_binding" "owner" {
  project = var.project-id
  for_each = toset([
    "roles/owner",
    "roles/container.admin"
  ])
  role = each.key

  members = [
    "user:${var.owner-email}",
  ]
}

resource "google_project_service" "sql-admin" {
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "kubernetes-engine" {
  service = "container.googleapis.com"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "cloud-run" {
  service = "run.googleapis.com"
}

# resource "google_artifact_registry_repository" "docker-demo-repo" {
#   provider      = google-beta

#   repository_id = "demo-repository"
#   description   = "Repository for demo"
#   format        = "DOCKER"
# }
