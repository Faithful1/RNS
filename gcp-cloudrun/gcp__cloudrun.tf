resource "google_cloud_run_v2_service" "main" {
  count    = var.create_cloudrun ? 1 : 0
  name     = "${local.namespace}-${var.stage}"
  project  = var.project_id
  location = var.deployment_region

  template {
    service_account = google_service_account.main[0].email

    annotations = {
      "autoscaling.knative.dev/minScale" = 1
      "autoscaling.knative.dev/maxScale" = 100
    }

    max_instance_request_concurrency = var.container_concurrency

    containers {
      image = var.image_name

      ports {
        container_port = var.container_port
      }

      env {
        name  = "TRIGGER_REBUILD"
        value = timestamp()
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }

  depends_on = [google_project_service.gcp_api[0]]
}
