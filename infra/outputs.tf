output "cloud_run_url" {
  description = "Public URL of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.backend.uri
}

output "artifact_registry_repository" {
  description = "Full path of the Artifact Registry Docker repo. Push images here."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}"
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name (project:region:instance)."
  value       = google_sql_database_instance.postgres.connection_name
}

output "firestore_database" {
  description = "Firestore database name (empty/unused - provisioned for a future migration)."
  value       = google_firestore_database.default.name
}
