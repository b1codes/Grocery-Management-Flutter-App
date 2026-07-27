resource "google_service_account" "cloud_run" {
  project      = var.project_id
  account_id   = "${var.service_name}-run-sa"
  display_name = "Cloud Run runtime SA for ${var.service_name}"

  depends_on = [google_project_service.apis]
}

resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"

  depends_on = [google_project_service.apis]
}

resource "google_project_iam_member" "cloud_run_firestore_user" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_iam_member" "django_secret_key_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.django_secret_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_iam_member" "gemini_api_key_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.gemini_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"

  depends_on = [google_project_service.apis]
}
