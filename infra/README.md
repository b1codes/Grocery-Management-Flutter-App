# GCP Infrastructure

Terraform for deploying the Django backend (`backend/`) to Google Cloud Platform:
Cloud Run (compute) + Cloud SQL for Postgres (database) + an empty Firestore
database (provisioned for a planned future migration, unused today) + Secret
Manager + Artifact Registry.

The Flutter app is mobile-only and is not deployed by this configuration.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [gcloud CLI](https://cloud.google.com/sdk/docs/install), authenticated: `gcloud auth application-default login`
- A GCP project with billing enabled
- Docker, for building the backend image

## One-time setup

### 1. Create the Terraform state bucket

A GCS backend can't create the bucket it stores its own state in, so create it manually once, replacing `YOUR_STATE_BUCKET`:

```bash
gcloud storage buckets create gs://YOUR_STATE_BUCKET --location=us-central1 --uniform-bucket-level-access
```

### 2. Initialize Terraform against that bucket

```bash
cd infra
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
```

### 3. Configure variables

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set project_id and gemini_api_key at minimum
```

`terraform.tfvars` is gitignored — never commit it.

## Deploying (two-pass bootstrap)

Cloud Run needs a valid container image to create the service, but the real
image needs the Artifact Registry repo that Terraform creates. So the first
deploy is two passes:

### Pass 1: stand up the infra with a placeholder image

```bash
terraform apply
```

This creates Artifact Registry, Cloud SQL, Secret Manager secrets, Firestore,
the service account, and a Cloud Run service running Google's placeholder
`hello` image (the `container_image` variable's default).

### Build and push the real image

```bash
REPO=$(terraform output -raw artifact_registry_repository)
gcloud builds submit ../backend --tag "$REPO/backend:latest"
```

(Or build locally with `docker build` + `docker push` if you'd rather not use Cloud Build.)

### Pass 2: point Cloud Run at the real image

```bash
REPO=$(terraform output -raw artifact_registry_repository)
terraform apply -var="container_image=$REPO/backend:latest"
```

Add that same `-var` (or set it in `terraform.tfvars`) on subsequent applies
so future plans don't try to revert to the placeholder image.

### Database migrations

After the first deploy with the real image, run migrations against the new
Cloud SQL database using the Cloud SQL Auth Proxy or `gcloud run jobs` /
`gcloud sql connect` — this isn't automated by this Terraform config.

## Variable reference

See `variables.tf` for the full list and defaults. Notably:

- `deletion_protection` (default `false`) — set `true` before treating this as real production data.
- `allow_unauthenticated` (default `true`) — the Cloud Run service is public since the mobile app calls it directly. Revisit once real request auth/rate-limiting exists in front of it.
- `django_allowed_hosts` (default `".run.app"`) — Django's leading-dot wildcard, valid for the default `*.run.app` URL Cloud Run assigns. Change this if you put a custom domain in front.

## Firestore

`firestore.tf` provisions an empty Firestore database now so a future
migration off Cloud SQL doesn't need a new infra step. Nothing in the Django
app talks to it yet — see
`docs/superpowers/specs/2026-07-27-gcp-terraform-infra-design.md`.

## Troubleshooting first apply

- IAM permission errors (e.g. Cloud Run failing to read a secret or connect
  to Cloud SQL) on the very first `apply` are often just IAM propagation
  delay — re-run `terraform apply` and it typically succeeds.
- `gcloud builds submit` may fail to push to Artifact Registry on some
  projects because the Cloud Build default service account lacks
  `roles/artifactregistry.writer` — grant that (and `roles/logging.logWriter`
  if logs fail to write) to the Cloud Build service account before retrying.

## Tearing down

```bash
terraform destroy
```

Note `deletion_protection` (the same variable) on both the Cloud SQL instance
and the Cloud Run service must be `false` (the default) for `destroy` to
remove them. Firestore is set to `deletion_policy = "DELETE"`, so it's
actually deleted on destroy rather than left behind (the provider default,
`ABANDON`, would otherwise silently leave it in GCP and break the next
`apply` since a project can only have one `(default)` database).
