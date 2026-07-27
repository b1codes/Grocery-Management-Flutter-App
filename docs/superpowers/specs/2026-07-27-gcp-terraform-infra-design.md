# Design Spec: GCP Terraform Infrastructure

**Date:** 2026-07-27
**Status:** Approved
**Topic:** Terraform scaffold to deploy the Django backend to Google Cloud Platform

## 1. Overview
This adds an `infra/` directory containing Terraform to deploy the existing Django backend (`backend/`) to GCP, plus the minimal application changes needed for that deployment to actually work: an env-driven `settings.py`, a `Dockerfile`, and two new production dependencies (`gunicorn`, `psycopg[binary]`). The Flutter app is mobile-only and is not deployed as part of this work. Real GCP project IDs, region, and secret values are left as variables for the user to fill in later — this scaffold is not applied to a live project as part of this task.

## 2. Scope Decisions
- **Single environment.** No dev/staging/prod split. Can be decomposed into workspaces later if needed.
- **Backend only.** No Cloud Storage/CDN hosting for the Flutter web build.
- **Compute: Cloud Run v2**, not GKE or a Compute Engine VM — serverless, scales to zero, least ops for a small app.
- **Database: Cloud SQL for Postgres** for the current Django ORM usage.
- **Future Firestore migration accounted for, not implemented.** The user has said the backend datastore will later move to Firestore (with the Firestore Emulator for local dev). This spec provisions an empty Firestore database (Native mode) now so that step doesn't need new infra later, but makes **no** code changes toward that cutover and does **not** wire up the emulator — both are explicitly out of scope until that migration actually starts.
- **Terraform state: GCS backend**, bucket created manually once (documented), since a backend configuration can't provision the very bucket it stores its state in.

## 3. Infrastructure Components (`infra/`)

| File | Resources |
|---|---|
| `versions.tf` | `terraform` block (required providers/version), `google` provider, `backend "gcs" {}` (partial config) |
| `variables.tf` | `project_id`, `region`, `service_name`, `container_image`, `db_tier`, `db_name`, `db_user`, `deletion_protection`, `allow_unauthenticated`, `django_allowed_hosts`, `firestore_location`, `gemini_api_key` (sensitive) |
| `apis.tf` | `google_project_service` for Cloud Run, SQL Admin, Secret Manager, Artifact Registry, Firestore, Cloud Build, Compute |
| `artifact_registry.tf` | Docker repo for the backend image |
| `cloud_sql.tf` | `google_sql_database_instance` (Postgres), `google_sql_database`, `google_sql_user`, `random_password` for the DB password |
| `firestore.tf` | `google_firestore_database` (Native mode, name `(default)`), empty/unused |
| `secrets.tf` | Secret Manager secrets + versions for `DJANGO_SECRET_KEY` (generated), DB password (from `cloud_sql.tf`), `GEMINI_API_KEY` (from the `gemini_api_key` variable) |
| `service_account.tf` | Cloud Run runtime service account; IAM bindings: `roles/cloudsql.client`, per-secret `secretAccessor`, `roles/datastore.user` |
| `cloud_run.tf` | `google_cloud_run_v2_service` — mounts the Cloud SQL instance as a volume at `/cloudsql`, reads env vars/secrets, scales 0→3; `google_cloud_run_v2_service_iam_member` for public invocation (gated by `allow_unauthenticated`) |
| `outputs.tf` | Cloud Run URL, Artifact Registry repo URL, Cloud SQL connection name, Firestore database name |
| `terraform.tfvars.example` | Documented placeholder values (committed) |
| `README.md` | Prereqs, bootstrap flow, deploy flow, variable reference |
| `.gitignore` | `*.tfstate*`, `.terraform/`, `terraform.tfvars` (real one, not the example) |

### Cloud SQL connectivity
Cloud SQL keeps a public IP but is only reachable through Cloud Run's built-in Cloud SQL Auth Proxy sidecar (via the `cloud_sql_instance` volume type) — no VPC connector or private networking needed for this scope.

### Bootstrap ordering problem and its resolution
Two ordering problems exist and are solved as follows:
1. **Image before infra**: Cloud Run needs a valid container image to create the service, but the image needs the Artifact Registry repo Terraform creates. Resolved by a documented two-pass apply: first apply with a placeholder public image (e.g. `us-docker.pkg.dev/cloudrun/container/hello`) to stand up the repo/DB/secrets, then build & push the real image, then re-apply with the real image tag.
2. **Hostname before deploy**: `ALLOWED_HOSTS` normally needs the exact Cloud Run URL, which isn't known before the service exists. Resolved by defaulting `DJANGO_ALLOWED_HOSTS` to `.run.app` — Django's leading-dot wildcard syntax matches any subdomain of `run.app`, so it's valid before and after deploy without a chicken-and-egg step.

## 4. Application Changes (`backend/`)

### `config/settings.py`
- `DEBUG` reads `DJANGO_DEBUG` env var (values `true`/`1`/`yes` → `True`), defaults `True` — unchanged for local dev.
- `ALLOWED_HOSTS` reads `DJANGO_ALLOWED_HOSTS` (comma-separated), defaults to `.run.app`.
- `DATABASES` stays SQLite unless `DB_ENGINE=postgres` is set, in which case it builds a Postgres config from `DB_NAME`/`DB_USER`/`DB_PASSWORD`/`DB_HOST`/`DB_PORT`. `DB_HOST` will be `/cloudsql/<connection-name>` on Cloud Run.
- Add `STATIC_ROOT` (currently missing, needed for `collectstatic` in the Docker build).
- No CORS package added — the Flutter client is mobile, not browser-based, so CORS is not applicable.
- No Firestore-related settings are added.

### `Pipfile`
- Add `gunicorn` (production WSGI server; `manage.py runserver` is dev-only).
- Add `psycopg[binary]` (Postgres driver for Django's `postgresql` backend).

### `Dockerfile` + `.dockerignore` (new, in `backend/`)
- `python:3.12-slim` base (matches `Pipfile`'s `python_version = "3.12"`).
- `pipenv install --deploy --system`, `collectstatic --noinput`, run via `gunicorn config.wsgi:application` on port 8080 (Cloud Run's expected port).

## 5. Error Handling / Safety Defaults
- `deletion_protection = false` on the Cloud SQL instance by default (a variable) so the user can iterate freely while first standing this up; call out in README to flip it before real production use.
- `allow_unauthenticated` defaults `true` since the mobile app calls the API directly with no gateway in front of it; README notes this should be revisited once real request auth/rate-limiting exists.
- Real secret values (`gemini_api_key`, project id, etc.) are supplied via a gitignored `terraform.tfvars`, never committed.

## 6. Testing / Verification
No live GCP project is touched as part of this task. Verification is:
- `terraform validate` and `terraform fmt -check` against the new config.
- `docker build` of the new `Dockerfile` against the existing `backend/` to confirm it builds and `collectstatic` succeeds.
- Existing Django checks/tests continue to pass with `DEBUG`/`DATABASES` defaults unchanged for local/dev use (no env vars set).

## 7. Success Criteria
- [ ] `infra/` contains a complete, internally consistent Terraform configuration for Cloud Run + Cloud SQL + Firestore + Secret Manager + Artifact Registry, parameterized via variables with no real credentials committed.
- [ ] `infra/README.md` documents the GCS state bucket bootstrap step and the two-pass image deploy flow clearly enough to follow without prior Terraform/GCP context.
- [ ] `backend/config/settings.py` works unchanged for local SQLite development with no env vars set, and switches to Postgres cleanly when `DB_ENGINE=postgres` is set.
- [ ] `backend/Dockerfile` builds successfully and runs `collectstatic`.
- [ ] `terraform validate` passes.
- [ ] No Firestore client code or emulator wiring is added anywhere in this change.
