############################
# LOAD-BALANCER:
# To create a load balancer please set create_loadbalancer to true
# With this config you can create multiple frontends by adding a new config
# in the frontend_config_map
# The loadbalancer resource creates one load balancer and uses path matchers
# to map each request to its frontend backend bucket.
############################

module "loadbalancer" {
  source              = "./gcp-loadbalancer"
  create_loadbalancer = true

  project_id           = "MY_PROJECT_ID"
  loadbalancer_name    = "https-lb-static-backend"
  default_redirect_url = "https://www.google.com"

  frontend_config_map = {
    frontend-1 = {
      service_name              = "genesis"
      environment               = "prod"
      domain_name               = "genesis.service.rns.ai." # Example existing frontend domain
      dnszone                   = "service-rns-ai"          # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
      dnszone_project_id        = "MY_PROJECT_ID"           # THIS IS THE PROJECT ID OF THE DNSZONE: SEE README FOR ERROR IF THIS IS NOT SET CORRECTLY
      enable_cdn                = true
      enable_versioning         = true
      bucket_push_account_email = "faithfulanere@gmail.com"
    }
    frontend-2 = {
      service_name              = "exodus"
      environment               = "prod"
      domain_name               = "exodus.service.rns.ai." # Example existing frontend domain
      dnszone                   = "service-rns-ai"         # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
      dnszone_project_id        = "MY_PROJECT_ID"          # THIS IS THE PROJECT ID OF THE DNSZONE: SEE README FOR ERROR IF THIS IS NOT SET CORRECTLY
      enable_cdn                = true
      enable_versioning         = true
      bucket_push_account_email = "faithfulanere@gmail.com"
    }
  }
}
