variable "bucket_project_id" {
  type        = string
  description = "The GCP project ID for the storage bucket."
}

variable "stage" {
  type        = string
  description = "The deployment stage, e.g., 'test' or 'prod'."
}

variable "backend_bucket_name" {
  type        = string
  description = "A unique identifier for the resource."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website or application."
}

variable "bucket_push_account_email" {
  type        = string
  description = "The email of a user or service account with the required permissions to push objects to the storage bucket."
}

variable "bucket_force_destroy" {
  type    = bool
  default = false

  description = <<-EOT
    Allows the deletion of the bucket if required.
    The bucket_force_destroy is normally set to false and should be true only
    during an asset offboarding.
  EOT
}

variable "enable_cdn" {
  type        = bool
  default     = true
  description = "value for enable_cdn. Could be either true or false."
}

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "value for enable_versioning. Could be either true or false."
}

variable "create_database" {
  type        = bool
  default     = false
  description = "turn on or off creation of database"
}
