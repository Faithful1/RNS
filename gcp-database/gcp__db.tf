resource "google_sql_database" "main" {
  count    = var.create_database ? 1 : 0
  project  = var.project_id
  instance = "rns-${var.stage}"
  name     = google_secret_manager_secret_version.db_name[0].secret_data
  depends_on = [
    google_secret_manager_secret.db_name[0],
    google_sql_database_instance.main[0]
  ]
}

resource "google_sql_user" "main" {
  count    = var.create_database ? 1 : 0
  project  = var.project_id
  instance = "rns-${var.stage}"
  name     = google_secret_manager_secret_version.db_username[0].secret_data
  password = google_secret_manager_secret_version.db_password[0].secret_data
  depends_on = [
    google_secret_manager_secret.db_password[0],
    google_secret_manager_secret.db_username[0],
    google_sql_database.main[0]
  ]
}
