# NOTE: these variables get overwritten by config/*.tfvars if you use the makefile
#       so you should set them in the according config/<envname>.tfvars file

variable "project_id" {
  type        = string
  description = "value for project_id"
}

variable "default_redirect_url" {
  type        = string
  description = "value for default_redirect_url"
}

variable "region" {
  type        = string
  default     = "europe-west3"
  description = "value for region to deploy the resources"
}

variable "frontend_config_map" {
  type        = map(map(string))
  default     = {}
  description = "value for config_map"
}

variable "loadbalancer_name" {
  type        = string
  default     = "frontend-lb"
  description = "value for loadbalancer_name"
}

variable "create_loadbalancer" {
  type        = bool
  default     = false
  description = "value for create_loadbalancer"
}
