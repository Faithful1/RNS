resource "google_storage_bucket" "page_bucket" {
  project                     = var.bucket_project_id
  name                        = "${substr(var.backend_bucket_name, 0, 56)}-public" #max allowed length is 63, 7 is reserved for -public hence 56
  location                    = "EU"
  force_destroy               = var.bucket_force_destroy
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  cors {
    origin          = [var.domain_name]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  versioning {
    enabled = var.enable_versioning
  }
}

resource "google_compute_backend_bucket" "page_backend_bucket" {
  project     = var.bucket_project_id
  name        = "${google_storage_bucket.page_bucket.name}-backend"
  description = "Hosts static website"
  bucket_name = google_storage_bucket.page_bucket.name
  enable_cdn  = var.enable_cdn
}
