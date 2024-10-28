module "backend" {
  for_each = var.create_loadbalancer ? var.frontend_config_map : {}

  source = "./lb-backend_bucket"

  backend_bucket_name       = each.key
  bucket_project_id         = var.project_id
  stage                     = each.value.environment
  domain_name               = each.value.domain_name
  enable_cdn                = each.value.enable_cdn
  bucket_push_account_email = each.value.bucket_push_account_email
  enable_versioning         = each.value.enable_versioning
}

resource "google_compute_managed_ssl_certificate" "main" {
  for_each = var.create_loadbalancer ? var.frontend_config_map : {}

  project = var.project_id
  name    = "cert-${var.loadbalancer_name}-${each.value.service_name}-${each.value.environment}"
  managed {
    domains = [each.value.domain_name]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "main" {
  count = var.create_loadbalancer ? 1 : 0

  project          = var.project_id
  name             = var.loadbalancer_name
  ssl_policy       = google_compute_ssl_policy.main[0].self_link
  url_map          = google_compute_url_map.main[0].self_link
  ssl_certificates = [for cert in google_compute_managed_ssl_certificate.main : cert.self_link]
}

resource "google_compute_url_map" "main" {
  count = var.create_loadbalancer ? 1 : 0

  project = var.project_id
  name    = "${var.loadbalancer_name}-url-map"

  default_url_redirect {
    host_redirect          = var.default_redirect_url
    strip_query            = true
    redirect_response_code = "TEMPORARY_REDIRECT"
  }

  dynamic "host_rule" {
    for_each = var.create_loadbalancer ? [for idx, config in var.frontend_config_map : config] : []
    content {
      hosts        = [host_rule.value["domain_name"]]
      path_matcher = "${host_rule.value["service_name"]}-${host_rule.value["environment"]}-allpaths"
    }
  }

  dynamic "path_matcher" {
    for_each = var.create_loadbalancer ? [for idx, config in var.frontend_config_map : config] : []
    content {
      name            = "${path_matcher.value["service_name"]}-${path_matcher.value["environment"]}-allpaths"
      default_service = module.backend[path_matcher.value["service_name"]].backend_name
      path_rule {
        paths   = ["/*"]
        service = module.backend[path_matcher.value["service_name"]].backend_name
      }
    }
  }
  depends_on = [
    module.backend,
    google_compute_managed_ssl_certificate.main
  ]
}

resource "google_compute_ssl_policy" "main" {
  count           = var.create_loadbalancer ? 1 : 0
  project         = var.project_id
  name            = "main-ssl-policy"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_global_forwarding_rule" "main" {
  count = var.create_loadbalancer ? 1 : 0

  project    = var.project_id
  ip_address = google_compute_global_address.main[0].address
  name       = "frontend-lb-forwarding-rule"
  target     = google_compute_target_https_proxy.main[0].self_link
  port_range = 443
}

resource "google_dns_record_set" "a_record" {
  for_each = var.create_loadbalancer ? { for idx, config in var.frontend_config_map : idx => config if contains(keys(config), "dnszone") } : {}

  project = try(each.value.dnszone_project_id, var.project_id)

  name         = each.value.domain_name
  type         = "A"
  ttl          = 300
  managed_zone = each.value.dnszone
  rrdatas      = [google_compute_global_address.main[0].address]
}

resource "google_compute_global_address" "main" {
  count = var.create_loadbalancer ? 1 : 0

  project    = var.project_id
  name       = "frontend-lb-ip"
  ip_version = "IPV4"
}
