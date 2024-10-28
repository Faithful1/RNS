
resource "google_storage_bucket_iam_binding" "public_binding" {
  bucket = google_storage_bucket.page_bucket.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_iam_binding" "cloudbuild_binding" {
  bucket = google_storage_bucket.page_bucket.name
  role   = "roles/storage.objectAdmin"
  members = [
    "user:${var.bucket_push_account_email}"
  ]
}

resource "google_project_iam_member" "cache_invalidation_permission" {
  project = var.bucket_project_id
  role    = "roles/compute.loadBalancerAdmin"
  member  = "user:${var.bucket_push_account_email}"
}
