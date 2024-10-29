data "google_client_config" "default" {}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_v2_service.main[0].location
  project     = google_cloud_run_v2_service.main[0].project
  service     = google_cloud_run_v2_service.main[0].name
  policy_data = data.google_iam_policy.noauth.policy_data
}
