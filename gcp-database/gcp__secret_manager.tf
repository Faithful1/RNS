resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_-" # will overwrite the default characters !@#$%&*()-_=+[]{}<>:?
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = "europe-west3"
      }
      replicas {
        location = "europe-west4"
      }
    }
  }

  depends_on = [google_project_service.gcp_api]
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret" "db_username" {
  project   = var.project_id
  secret_id = "POSTGRES_USER"
  replication {
    user_managed {
      replicas {
        location = "europe-west3"
      }
      replicas {
        location = "europe-west4"
      }
    }
  }

  depends_on = [google_project_service.gcp_api]
}

resource "google_secret_manager_secret_version" "db_username" {
  secret      = google_secret_manager_secret.db_username.id
  secret_data = var.project_id
}

resource "google_secret_manager_secret" "db_name" {
  project   = var.project_id
  secret_id = "DB_NAME"
  replication {
    user_managed {
      replicas {
        location = "europe-west3"
      }
      replicas {
        location = "europe-west4"
      }
    }
  }

  depends_on = [google_project_service.gcp_api]
}

resource "google_secret_manager_secret_version" "db_name" {
  secret      = google_secret_manager_secret.db_name.id
  secret_data = var.project_id
}
