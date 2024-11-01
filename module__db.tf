############################
# DB-module:
# To create a database that runs on postgres engine, set create_db to true
# With this config you can create multiple postgres instances by adding a new config
# in the db_config_map
############################

module "database" {
  source          = "./gcp-database"
  create_database = true

  project_id = "MY_PROJECT_ID"
  stage      = "prod"
  db_version = "POSTGRES_15"
  db_instances = {
    "rns-db-instance-prod" = {
      db_tier                         = "db-custom-4-16384"
      db_instance_deletion_protection = false
      db_disk_size                    = 10
      database_flags = [
        {
          name  = "max_connections",
          value = 20
        }
      ]
    }
  }
  google_api_list = [
    "appengine.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}
