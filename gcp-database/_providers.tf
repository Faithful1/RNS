terraform {
  required_version = "~> 1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6"
    }
    google-beta = {
      source  = "google-beta"
      version = "~> 6"
    }
  }

  backend "local" {}
}
