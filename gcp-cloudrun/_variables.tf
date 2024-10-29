# NOTE: these variables get overwritten by config/*.tfvars if you use the makefile
#       so you should set them in the according config/<envname>.tfvars file

variable "project_id" {
  type        = string
  default     = ""
  description = "value for project_id"
}

variable "stage" {
  type = string
}

variable "deployment_region" {
  default = "europe-west3"
  type    = string
}

variable "create_cloudrun" {
  type        = bool
  default     = false
  description = "value for create_cloudrun"
}

variable "google_api_list" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "cloudapis.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
  description = "List of resource api used in the project"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "container_concurrency" {
  type    = number
  default = 100
}

variable "image_name" {
  type    = string
  default = "nginx"
}
