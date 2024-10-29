resource "google_project_service" "gcp_api" {
  for_each           = var.create_cloudrun ? toset(var.google_api_list) : []
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
