############################
# CLOUDRUN:
# To create a cloudrun service set create_cloudrun to true
# 
############################

module "cloudrun" {
  source          = "./gcp-cloudrun"
  create_cloudrun = true

  project_id            = "MY_PROJECT_ID"
  stage                 = "prod"
  image_name            = "nginx"
  container_concurrency = 100
  container_port        = 80
}
