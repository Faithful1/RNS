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

variable "database_config_map" {
  default     = {}
  description = "Config for frontend pipeline consumption"
}

variable "db_version" {
  type = string
}

variable "db_instances" {
  default = {}
}

variable "create_database" {
  type        = bool
  default     = false
  description = "value for create_loadbalancer"
}

variable "google_api_list" {
  type        = list(string)
  default     = []
  description = "The list of apis required by the project"
}
