resource "random_password" "db_password" {
  count = var.create_database ? 1 : 0

  length           = 16
  special          = true
  override_special = "_-" # will overwrite the default characters !@#$%&*()-_=+[]{}<>:?
}

resource "google_secret_manager_secret" "db_password" {
  count = var.create_database ? 1 : 0

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

  depends_on = [google_project_service.gcp_api[0]]
}

resource "google_secret_manager_secret_version" "db_password" {
  count       = var.create_database ? 1 : 0
  secret      = google_secret_manager_secret.db_password[0].id
  secret_data = random_password.db_password[0].result
}

resource "google_secret_manager_secret" "db_username" {
  count     = var.create_database ? 1 : 0
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

  depends_on = [google_project_service.gcp_api[0]]
}

resource "google_secret_manager_secret_version" "db_username" {
  count       = var.create_database ? 1 : 0
  secret      = google_secret_manager_secret.db_username[0].id
  secret_data = var.project_id
}

resource "google_secret_manager_secret" "db_name" {
  count     = var.create_database ? 1 : 0
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

  depends_on = [google_project_service.gcp_api[0]]
}

resource "google_secret_manager_secret_version" "db_name" {
  count       = var.create_database ? 1 : 0
  secret      = google_secret_manager_secret.db_name[0].id
  secret_data = var.project_id
}
