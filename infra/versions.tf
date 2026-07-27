terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Partial configuration: the state bucket is supplied at `terraform init`
  # time, not hardcoded here, since it must exist before this backend can
  # use it. See README.md for the one-time bootstrap step.
  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}
