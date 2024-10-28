project_id    = "dgcp-sandbox-faithful-anere"

############################
# LOAD-BALANCER:
# To create a load balancer please set create_loadbalancer to true
# With this config you can create multiple frontends by adding a new config
# in the frontend_config_map
# The loadbalancer resource creates one load balancer and uses path matchers
# to map each request to its frontend backend bucket.
############################

create_loadbalancer = true

loadbalancer_name = "https-lb-static-backend"

default_redirect_url = "https://www.google.com"

frontend_config_map = {
    genesis = {
        service_name               = "genesis"
        environment                = "prod"
        domain_name               = "genesis.service.rns.ai." # Example existing frontend domain
        dnszone                   = "service-rns-ai"  # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
        dnszone_project_id        = "dgcp-sandbox-faithful-anere" # THIS IS THE PROJECT ID OF THE DNSZONE
        enable_cdn                   = true
        enable_versioning = true
        bucket_push_account_email = "fanere@deloitte.de"
    }
    exodus = {
        service_name               = "exodus"
        environment                = "prod"
        domain_name               = "exodus.service.rns.ai." # Example existing frontend domain
        dnszone                   = "service-rns-ai"  # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
        dnszone_project_id        = "dgcp-sandbox-faithful-anere" # THIS IS THE PROJECT ID OF THE DNSZONE
        enable_cdn                   = true
        enable_versioning = true
        bucket_push_account_email = "fanere@deloitte.de"
    }
}

