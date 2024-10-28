resource "google_sql_database" "main" {
  project  = var.project_id
  instance = "rns-${var.stage}"
  name     = google_secret_manager_secret_version.db_name.secret_data
}

resource "google_sql_user" "main" {
  project  = var.project_id
  instance = "rns-${var.stage}"
  name     = google_secret_manager_secret_version.db_username.secret_data
  password = google_secret_manager_secret_version.db_password.secret_data
  depends_on = [
    google_secret_manager_secret.db_password,
    google_secret_manager_secret.db_username,
  ]
}
