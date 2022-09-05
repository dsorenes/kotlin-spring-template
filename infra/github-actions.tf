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
