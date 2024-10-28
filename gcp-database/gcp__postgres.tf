resource "google_sql_database_instance" "main" {
  for_each            = var.create_database ? var.db_instances : {}
  project             = var.project_id
  name                = each.key
  region              = var.deployment_region
  database_version    = var.db_version
  deletion_protection = each.value.db_instance_deletion_protection

  settings {
    tier      = each.value.db_tier
    disk_size = each.value.db_disk_size

    ip_configuration {
      ipv4_enabled = true
    }

    dynamic "database_flags" {
      for_each = each.value.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }

  depends_on = [google_project_service.gcp_api]
}
