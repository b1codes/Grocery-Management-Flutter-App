# Provisioned now for a planned future migration off Cloud SQL. Nothing in
# the Django app reads or writes to this database yet - see
# docs/superpowers/specs/2026-07-27-gcp-terraform-infra-design.md.
resource "google_firestore_database" "default" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.firestore_location
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.apis]
}
