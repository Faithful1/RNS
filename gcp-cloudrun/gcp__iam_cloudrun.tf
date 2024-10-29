resource "google_service_account" "main" {
  count        = var.create_cloudrun ? 1 : 0
  project      = var.project_id
  account_id   = "${local.namespace}-${var.stage}"
  display_name = "Service Account created by terraform"
}

resource "google_project_iam_member" "cloudrun_discovery" {
  count   = var.create_cloudrun ? 1 : 0
  project = var.project_id
  role    = "roles/run.viewer"
  member  = google_service_account.main[0].member
}
