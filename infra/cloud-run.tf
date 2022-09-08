resource "google_cloud_run_service" "default" {
  name     = "cloudrun-demo"
  location = "europe-north1"

  template {
    spec {
      containers {
        image = "europe-north1-docker.pkg.dev/daniel-361210/demo-repo/demo:3.1"
        env {
          name = "SPRING_CLOUD_GCP_SQL_INSTANCE_CONNECTION_NAME"
          value = var.db-instance-name
        }
      }

      service_account_name = google_service_account.cloud-run.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_service_account" "cloud-run" {
  account_id   = "cloud-run"
  display_name = "Service Account for cloud run"
  project      = var.project-id
}

resource "google_project_iam_member" "cloud-run" {
  project = var.project-id
  for_each = toset([
    "roles/cloudsql.client",
  ])
  role   = each.key
  member = "serviceAccount:${google_service_account.cloud-run.email}"
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
