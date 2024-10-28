output "backend_name" {
  value       = google_compute_backend_bucket.page_backend_bucket.self_link
  description = "The self-link of the created backend bucket."
}
