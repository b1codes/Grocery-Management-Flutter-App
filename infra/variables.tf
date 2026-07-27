variable "project_id" {
  description = "GCP project ID to deploy into."
  type        = string
}

variable "region" {
  description = "GCP region for regional resources (Cloud Run, Artifact Registry, Cloud SQL)."
  type        = string
  default     = "us-central1"
}

variable "firestore_location" {
  description = "Firestore location ID. Distinct from `region` - see https://cloud.google.com/firestore/docs/locations."
  type        = string
  default     = "nam5"
}

variable "service_name" {
  description = "Name of the Cloud Run service, and prefix for related resource names."
  type        = string
  default     = "grocery-backend"
}

variable "container_image" {
  description = "Full image reference for the Cloud Run service. Use the default placeholder for the first apply (before the real image exists in Artifact Registry), then re-apply with the real image tag."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "cpu" {
  description = "CPU allocated to the Cloud Run container."
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocated to the Cloud Run container."
  type        = string
  default     = "512Mi"
}

variable "max_instance_count" {
  description = "Maximum Cloud Run instance count."
  type        = number
  default     = 3
}

variable "allow_unauthenticated" {
  description = "Whether the Cloud Run service allows unauthenticated invocations. Defaults true since the mobile app calls the API directly with no gateway in front of it."
  type        = bool
  default     = true
}

variable "django_allowed_hosts" {
  description = "Comma-separated Django ALLOWED_HOSTS for the deployed service. Defaults to '.run.app' (Django's leading-dot wildcard) so it's valid before the exact Cloud Run URL is known."
  type        = string
  default     = ".run.app"
}

variable "db_tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-f1-micro"
}

variable "db_name" {
  description = "Name of the application database."
  type        = string
  default     = "grocery"
}

variable "db_user" {
  description = "Postgres user for the application."
  type        = string
  default     = "grocery_app"
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the Cloud SQL instance. Defaults false for ease of iteration during initial setup - set true before real production use."
  type        = bool
  default     = false
}

variable "gemini_api_key" {
  description = "Value for the GEMINI_API_KEY secret, consumed by the Django app's google-generativeai integration. Supply via terraform.tfvars (gitignored) or TF_VAR_gemini_api_key - never commit the real value."
  type        = string
  sensitive   = true
}
