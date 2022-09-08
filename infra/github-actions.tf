resource "google_service_account" "github-actions" {
  account_id   = "github-actions"
  display_name = "Service Account for Github actions"
  project      = var.project-id
}

resource "google_project_iam_member" "github-actions" {
  project = var.project-id
  for_each = toset([
    "roles/artifactregistry.admin",
  ])
  role   = each.key
  member = "serviceAccount:${google_service_account.github-actions.email}"
}

resource "google_artifact_registry_repository_iam_member" "repo-iam" {
  provider = google-beta

  location   = "europe-north1"
  repository = "demo-repo"
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${google_service_account.github-actions.email}"
}
