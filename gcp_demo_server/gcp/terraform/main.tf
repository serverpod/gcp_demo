# Set up and configure Terraform and the Google Cloud provider.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("credentials.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Add a Serverpod module configured for production. Full documentation is
# available at https://github.com/serverpod/google_cloud_serverpod_gce
module "serverpod_production" {
  # References the Serverpod module from GitHub.
  source = "github.com/serverpod/google_cloud_serverpod_gce?ref=dev"

  # Required parameters.
  project = var.project
  service_account_email = var.service_account_email

  runmode = "production"

  region = var.region
  zone   = var.zone

  dns_managed_zone = var.dns_managed_zone
  top_domain = var.top_domain

  # Size of the auto scaling group.
  autoscaling_min_size = 1
  autoscaling_max_size = 2
  
  database_password = var.DATABASE_PASSWORD_PRODUCTION

  # Makes it possible to SSH into the individual server instances.
  enable_ssh = true
}

# module "serverpod_staging" {
#   source = "./modules/serverpod"
#   count  = var.enable_staging ? 1 : 0

#   project = var.project
#   runmode = "staging"

#   region = var.region
#   zone   = var.zone

#   top_domain = "examplepod.com"

#   autoscaling_min_size = var.autoscaling_min_size
#   autoscaling_max_size = var.autoscaling_max_size

#   service_account_email = var.service_account_email

#   database_password = var.DATABASE_PASSWORD_STAGING
# }