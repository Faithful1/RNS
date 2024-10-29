# RNS Terraform Modules

This repository contains Terraform modules for deploying Google Cloud Platform (GCP) infrastructure, including:

- **Cloud Run Services**
- **PostgreSQL Databases**
- **Load Balancer Service**

Each module is located in its respective file and can be enabled by setting the appropriate `create_*` variable to `true`.

---

## How to Use

1. **Navigate to the Desired Module:**
   - To deploy a Cloud Run service, navigate to the `module_cloudrun.tf` file.
   - To deploy a PostgreSQL database, navigate to the `module_db.tf` file.
   - To deploy a Load Balancer service, navigate to the `module_lb.tf` file.

2. **Enable the Module:**
   - Inside each module file, there is a variable named `create_*` (e.g., `create_cloudrun`, `create_database`, `create_loadbalancer`).
   - To enable the creation of any or all of the resources, set the corresponding variable to `true`.

---

## Module Details

### 1. **Cloud Run Module (`module_cloudrun.tf`)**
- **Description**: This module is used to create a GCP Cloud Run service.
- **Configuration**: 
  - Enable by setting `create_cloudrun = true`.
  - Customize the service by modifying parameters such as:
    - `project_id`: GCP Project ID.
    - `stage`: Environment stage (e.g., `prod`).
    - `image_name`: The name of the container image.
    - `max_concurrency`, `max_instances`, `port`: Define concurrency and port settings.

### 2. **Database Module (`module_db.tf`)**
- **Description**: 
This module sets up a PostgreSQL instance, creates adatabase on GCP and stores all its details in secret manager.
- **Configuration**: 
  - Enable by setting `create_database = true`.
  - Configure the following parameters:
    - `project_id`: GCP Project ID.
    - `stage`: Environment stage (e.g., `prod`).
    - `db_version`: Version of PostgreSQL (e.g., `POSTGRES_15`).
    - `db_instances`: Configure database instance details such as disk size, instance name, and flags.

### 3. **Load Balancer Module (`module_lb.tf`)**
- **Description**: This module provisions a GCP Load Balancer.
- **Configuration**:
  - Enable by setting `create_loadbalancer = true`.
  - Parameters include:
    - `project_id`: GCP Project ID.
    - `loadbalancer_name`: Name of the load balancer.
    - `frontend_config_map`: Define frontend configuration for routing traffic to backend buckets.

---

## Example Usage

### Enable Cloud Run:
In the `module_cloudrun.tf` file, set:

```hcl
create_cloudrun = true

module "cloudrun" {
  source          = "./gcp-cloudrun"
  create_cloudrun = true

  project_id            = "MY_PROJECT_ID"
  stage                 = "prod"
  image_name            = "nginx"
  container_concurrency = 100
  container_port        = 80
}

This config would create an nginx service which is accessible 
via the cloudrun url provided by gcp

Now run `terraform init` and `terraform apply`
```

### Enable db creation:
In the `module_db .tf` file, set:

```hcl
create_database= true

module "database" {
  source          = "./gcp-database"
  create_database = true

  project_id = "MY_PROJECT_ID"
  stage      = "prod"
  db_version = "POSTGRES_15"
  db_instances = {  # This creates multiple cloud sql instances
    "rns-prod" = {
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

Now run `terraform init` and `terraform apply`
```


### Enable loadbalancer:
In the `module_lb .tf` file, set:

```hcl
create_database= true

module "loadbalancer" {
  source              = "./gcp-loadbalancer"
  create_loadbalancer = true

  project_id           = "MY_PROJECT_ID"
  loadbalancer_name    = "https-lb-static-backend"
  default_redirect_url = "https://www.google.com"

  frontend_config_map = {
    genesis = {
      service_name              = "genesis"
      environment               = "prod"
      domain_name               = "genesis.service.rns.ai." # Example existing frontend domain
      dnszone                   = "service-rns-ai"          # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
      dnszone_project_id        = "MY_PROJECT_ID"           # THIS IS THE PROJECT ID OF THE DNSZONE: SEE README FOR ERROR IF THIS IS NOT SET CORRECTLY
      enable_cdn                = true
      enable_versioning         = true
      bucket_push_account_email = "faithfulanere@gmail.com"
    }
    exodus = {
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

After filling in the details run `terraform init` and `terraform apply`, 
this will create two backend buckets mapped in one load balancer in which you
can push an angular frontend or react frontend in cloud storage bucket.
It is then accessible via the domain name specified in the config. e.g 
`genesis.service.rns.ai` or `genesis.service.rns.ai`
The loadbalancer would use path based matching to map requests to the
correct backend bucket.

## NOTE
if you fail to set a project id that has a dnszone or 
domain existing in it you would get the error in the screenshot below

set these three values and make sure they exist in the sprcified project.
The resource will also be created if you dont have a domain to test too.
but tf will report that an a-record needs an existing domain
as seen in the screenshot below.

domain_name               = "genesis.service.rns.ai."  # Example existing frontend domain
dnszone                   = "service-rns-ai"           # MAKE SURE THIS DNSZONE EXISTS IN THE PROJECT
dnszone_project_id        = "MY_PROJECT_ID"            # THIS IS THE PROJECT ID OF THE DNSZONE: 
                                                       # SEE BELOW FOR ERROR IF THIS IS NOT SET CORRECTLY
                                                       # LOADBALANCER WILL STILL BE CREATED AND 
                                                       # CAN BE VIEWED IN GCP CONSOLE
```

![error message](./image-2.png)

Feel free to email me for further questions