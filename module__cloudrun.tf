############################
# CLOUDRUN:
# To create a cloudrun service set create_cloudrun to true
# 
############################
module "cloudrun" {
  source          = "./gcp-cloudrun"
  create_cloudrun = false

  project_id            = "dgcp-sandbox-faithful-anere"
  stage                 = "prod"
  container_concurrency = 100
  image_name            = "nginx"
  container_port        = 80
}
