resource "google_artifact_registry_repository" "backend" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.service_name}-repo"
  format        = "DOCKER"
  description   = "Container images for the ${var.service_name} Cloud Run service."

  depends_on = [google_project_service.apis]
}
