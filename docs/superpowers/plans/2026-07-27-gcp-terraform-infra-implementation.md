# GCP Terraform Infra Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an `infra/` Terraform scaffold that deploys the Django backend to GCP (Cloud Run + Cloud SQL), plus the minimal Django/Docker changes needed for that deployment to work.

**Architecture:** Cloud Run v2 runs the Django container and connects to a Cloud SQL Postgres instance through Cloud Run's built-in Cloud SQL Auth Proxy volume mount (no VPC connector). Secret Manager holds generated/provided secrets. An empty Firestore database is provisioned for a planned future migration but nothing reads/writes it yet. Django's settings become env-driven via a small testable `config/env.py` module, defaulting to today's local SQLite behavior when no env vars are set.

**Tech Stack:** Terraform (`google`, `random` providers), Docker, gunicorn, psycopg (binary), Django 5.2, Pipenv.

Spec: `docs/superpowers/specs/2026-07-27-gcp-terraform-infra-design.md`

## Global Constraints
- Terraform `>= 1.5.0`; `google` provider `~> 6.0`; `random` provider `~> 3.6`.
- Pipfile pins `python_version = "3.12"` — Docker image must be `python:3.12-slim` to match.
- No CORS package is added — the Flutter client is mobile-only, not browser-based.
- No Firestore client code or emulator wiring is added anywhere in this change (per spec §2 and §7).
- Real secrets/credentials are never committed — `infra/terraform.tfvars` is gitignored, only `terraform.tfvars.example` is committed.
- Local/dev Django behavior must be unchanged when no new env vars are set (`DEBUG=True`, SQLite, `ALLOWED_HOSTS=[]`).
- `deletion_protection` defaults `false`, `allow_unauthenticated` defaults `true` (both spec-mandated defaults, both Terraform variables so they can be changed later).

---

### Task 1: Testable env-parsing helpers for Django settings

**Files:**
- Create: `backend/config/env.py`
- Create: `backend/config/tests.py`

**Interfaces:**
- Produces: `get_bool_env(name: str, default: bool) -> bool`
- Produces: `get_list_env(name: str, default: list[str]) -> list[str]`
- Produces: `build_database_config(base_dir: Path) -> dict` — returns a Django `DATABASES['default']` dict; SQLite unless `DB_ENGINE=postgres` env var is set, in which case it builds a Postgres config from `DB_NAME`/`DB_USER`/`DB_PASSWORD`/`DB_HOST`/`DB_PORT`.

- [ ] **Step 1: Write the failing tests**

Create `backend/config/tests.py`:

```python
import unittest
from pathlib import Path
from unittest import mock

from config.env import build_database_config, get_bool_env, get_list_env


class GetBoolEnvTests(unittest.TestCase):
    @mock.patch.dict('os.environ', {}, clear=True)
    def test_returns_default_when_unset(self):
        self.assertTrue(get_bool_env('DJANGO_DEBUG', True))
        self.assertFalse(get_bool_env('DJANGO_DEBUG', False))

    @mock.patch.dict('os.environ', {'DJANGO_DEBUG': 'False'}, clear=True)
    def test_parses_false(self):
        self.assertFalse(get_bool_env('DJANGO_DEBUG', True))

    @mock.patch.dict('os.environ', {'DJANGO_DEBUG': 'true'}, clear=True)
    def test_parses_true_case_insensitive(self):
        self.assertTrue(get_bool_env('DJANGO_DEBUG', False))


class GetListEnvTests(unittest.TestCase):
    @mock.patch.dict('os.environ', {}, clear=True)
    def test_returns_default_when_unset(self):
        self.assertEqual(get_list_env('DJANGO_ALLOWED_HOSTS', ['.run.app']), ['.run.app'])

    @mock.patch.dict('os.environ', {'DJANGO_ALLOWED_HOSTS': 'example.com, api.example.com'}, clear=True)
    def test_splits_and_strips_commas(self):
        self.assertEqual(
            get_list_env('DJANGO_ALLOWED_HOSTS', []),
            ['example.com', 'api.example.com'],
        )


class BuildDatabaseConfigTests(unittest.TestCase):
    def setUp(self):
        self.base_dir = Path('/tmp/fake-base-dir')

    @mock.patch.dict('os.environ', {}, clear=True)
    def test_defaults_to_sqlite(self):
        config = build_database_config(self.base_dir)
        self.assertEqual(config['default']['ENGINE'], 'django.db.backends.sqlite3')
        self.assertEqual(config['default']['NAME'], self.base_dir / 'db.sqlite3')

    @mock.patch.dict('os.environ', {
        'DB_ENGINE': 'postgres',
        'DB_NAME': 'grocery',
        'DB_USER': 'grocery_app',
        'DB_PASSWORD': 'secret',
        'DB_HOST': '/cloudsql/proj:region:instance',
        'DB_PORT': '5432',
    }, clear=True)
    def test_switches_to_postgres(self):
        config = build_database_config(self.base_dir)
        self.assertEqual(config['default'], {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'grocery',
            'USER': 'grocery_app',
            'PASSWORD': 'secret',
            'HOST': '/cloudsql/proj:region:instance',
            'PORT': '5432',
        })
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd backend && python manage.py test config.tests -v 2`
Expected: FAIL/ERROR — `ModuleNotFoundError: No module named 'config.env'` (module doesn't exist yet).

- [ ] **Step 3: Write the implementation**

Create `backend/config/env.py`:

```python
import os
from pathlib import Path


def get_bool_env(name: str, default: bool) -> bool:
    value = os.environ.get(name)
    if value is None:
        return default
    return value.strip().lower() in ('true', '1', 'yes')


def get_list_env(name: str, default: list) -> list:
    value = os.environ.get(name)
    if value is None or value == '':
        return default
    return [item.strip() for item in value.split(',') if item.strip()]


def build_database_config(base_dir: Path) -> dict:
    if os.environ.get('DB_ENGINE') != 'postgres':
        return {
            'default': {
                'ENGINE': 'django.db.backends.sqlite3',
                'NAME': base_dir / 'db.sqlite3',
            }
        }

    return {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': os.environ.get('DB_NAME', 'grocery'),
            'USER': os.environ.get('DB_USER', 'grocery_app'),
            'PASSWORD': os.environ.get('DB_PASSWORD', ''),
            'HOST': os.environ.get('DB_HOST', ''),
            'PORT': os.environ.get('DB_PORT', '5432'),
        }
    }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd backend && python manage.py test config.tests -v 2`
Expected: `OK` — 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add backend/config/env.py backend/config/tests.py
git commit -m "feat(backend): add testable env-parsing helpers for settings"
```

---

### Task 2: Wire settings.py to the new env helpers

**Files:**
- Modify: `backend/config/settings.py:13-31` (imports, `DEBUG`, `ALLOWED_HOSTS`)
- Modify: `backend/config/settings.py:87-92` (`DATABASES`)
- Modify: `backend/config/settings.py:126-129` (add `STATIC_ROOT`)

**Interfaces:**
- Consumes: `get_bool_env`, `get_list_env`, `build_database_config` from Task 1's `backend/config/env.py`.

- [ ] **Step 1: Update imports and `DEBUG`/`ALLOWED_HOSTS`**

In `backend/config/settings.py`, replace:

```python
import os
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

AUTH_USER_MODEL = 'authentication.User'


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'django-insecure-q2mb41a+!lvya0flqz8ecl0lm@#@cx&=4&n6xou)*np713ioq8')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []
```

with:

```python
import os
from pathlib import Path

from config.env import build_database_config, get_bool_env, get_list_env

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

AUTH_USER_MODEL = 'authentication.User'


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'django-insecure-q2mb41a+!lvya0flqz8ecl0lm@#@cx&=4&n6xou)*np713ioq8')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = get_bool_env('DJANGO_DEBUG', True)

# Empty by default so local DEBUG=True dev (which auto-allows localhost) is
# unaffected. The GCP infra sets DJANGO_ALLOWED_HOSTS explicitly on deploy.
ALLOWED_HOSTS = get_list_env('DJANGO_ALLOWED_HOSTS', [])
```

- [ ] **Step 2: Update `DATABASES`**

Replace:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

with:

```python
DATABASES = build_database_config(BASE_DIR)
```

- [ ] **Step 3: Add `STATIC_ROOT`**

Replace:

```python
STATIC_URL = 'static/'
```

with:

```python
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
```

- [ ] **Step 4: Verify no regression to local/dev behavior**

Run: `cd backend && python manage.py check`
Expected: `System check identified no issues (0 silenced).`

Run: `cd backend && python manage.py test`
Expected: `OK` — full existing suite plus Task 1's new tests all pass, with no env vars set (confirms SQLite/DEBUG/empty-ALLOWED_HOSTS defaults are unchanged).

- [ ] **Step 5: Commit**

```bash
git add backend/config/settings.py
git commit -m "feat(backend): make DEBUG/ALLOWED_HOSTS/DATABASES env-driven for GCP deploy"
```

---

### Task 3: Add production dependencies (gunicorn, psycopg) and regenerate the lock file

**Files:**
- Modify: `backend/Pipfile`
- Modify: `backend/Pipfile.lock` (regenerated, not hand-edited)

**Interfaces:** None (dependency-only change).

- [ ] **Step 1: Add the new packages to Pipfile**

In `backend/Pipfile`, under `[packages]`, add two lines so the block reads:

```toml
[packages]
django = "*"
djangorestframework = "*"
phonenumbers = "*"
python-dateutil = "*"
django-filter = "*"
google-generativeai = "*"
gunicorn = "*"
psycopg = {extras = ["binary"], version = "*"}
```

- [ ] **Step 2: Regenerate Pipfile.lock using a Python 3.12 environment**

The host machine may not have Python 3.12 installed (Pipfile pins `python_version = "3.12"`), so regenerate the lock file inside a disposable container that has the right interpreter, rather than requiring a local pyenv install:

Run:
```bash
docker run --rm -v "$(pwd)/backend:/app" -w /app python:3.12-slim \
  bash -c "pip install --quiet pipenv && pipenv lock"
```
Expected: command exits 0 and `backend/Pipfile.lock` is modified (check with `git diff --stat backend/Pipfile.lock` — it should show changes).

- [ ] **Step 3: Sanity-check the lock file is valid TOML/JSON and matches the Pipfile hash**

Run: `cd backend && python3 -c "import json; d = json.load(open('Pipfile.lock')); print('gunicorn' in d['default'], 'psycopg' in d['default'])"`
Expected: `True True`

- [ ] **Step 4: Commit**

```bash
git add backend/Pipfile backend/Pipfile.lock
git commit -m "feat(backend): add gunicorn and psycopg for production deployment"
```

---

### Task 4: Dockerfile for Cloud Run

**Files:**
- Create: `backend/Dockerfile`
- Create: `backend/.dockerignore`

**Interfaces:**
- Consumes: `backend/Pipfile` / `backend/Pipfile.lock` from Task 3; `STATIC_ROOT` from Task 2 (so `collectstatic` has somewhere to write).
- Produces: a container image listening on port `8080`, matching what `infra/cloud_run.tf` (Task 7) expects.

- [ ] **Step 1: Write `backend/.dockerignore`**

```
.venv
__pycache__
*.pyc
db.sqlite3
staticfiles
.git
.dockerignore
Dockerfile
```

- [ ] **Step 2: Write `backend/Dockerfile`**

```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN pip install pipenv

COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8080

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8080", "--workers", "2"]
```

- [ ] **Step 3: Build the image locally to verify it works**

Run: `docker build -t grocery-backend:test backend`
Expected: build completes successfully; the `collectstatic` layer's output includes `... static files copied` (or similar) with no errors, and the final layer succeeds.

- [ ] **Step 4: Commit**

```bash
git add backend/Dockerfile backend/.dockerignore
git commit -m "feat(backend): add Dockerfile for Cloud Run deployment"
```

---

### Task 5: Terraform foundation — providers, variables, APIs, Artifact Registry

**Files:**
- Create: `infra/versions.tf`
- Create: `infra/variables.tf`
- Create: `infra/apis.tf`
- Create: `infra/artifact_registry.tf`

**Interfaces:**
- Produces: every `var.*` used by later tasks (full list below) — later tasks must not introduce new variables not declared here.
- Produces: `google_project_service.apis` (for_each over enabled API list) — later resources depend on this.
- Produces: `google_artifact_registry_repository.backend`.

- [ ] **Step 1: Write `infra/versions.tf`**

```hcl
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
```

- [ ] **Step 2: Write `infra/variables.tf`**

```hcl
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
```

- [ ] **Step 3: Write `infra/apis.tf`**

```hcl
locals {
  enabled_apis = [
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.enabled_apis)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
```

- [ ] **Step 4: Write `infra/artifact_registry.tf`**

```hcl
resource "google_artifact_registry_repository" "backend" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.service_name}-repo"
  format        = "DOCKER"
  description   = "Container images for the ${var.service_name} Cloud Run service."

  depends_on = [google_project_service.apis]
}
```

- [ ] **Step 5: Validate**

Run: `cd infra && terraform init -backend=false && terraform validate`
Expected: `Success! The configuration is valid.` (`gemini_api_key` has no default, but `validate` doesn't require variable values — only `plan`/`apply` do.)

Run: `terraform fmt -check -recursive`
Expected: no output, exit code 0 (files are already correctly formatted as written above).

- [ ] **Step 6: Commit**

```bash
git add infra/versions.tf infra/variables.tf infra/apis.tf infra/artifact_registry.tf
git commit -m "feat(infra): add Terraform foundation (providers, variables, APIs, Artifact Registry)"
```

---

### Task 6: Terraform data layer — Cloud SQL, Firestore, Secret Manager

**Files:**
- Create: `infra/cloud_sql.tf`
- Create: `infra/firestore.tf`
- Create: `infra/secrets.tf`

**Interfaces:**
- Consumes: `var.project_id`, `var.region`, `var.service_name`, `var.db_tier`, `var.db_name`, `var.db_user`, `var.deletion_protection`, `var.firestore_location`, `var.gemini_api_key`, `google_project_service.apis` (Task 5).
- Produces: `google_sql_database_instance.postgres` (with `.connection_name`), `google_sql_database.app`, `google_sql_user.app`, `random_password.db_password`.
- Produces: `google_firestore_database.default`.
- Produces: `google_secret_manager_secret.django_secret_key`, `google_secret_manager_secret.db_password`, `google_secret_manager_secret.gemini_api_key` (each with a matching `_version` resource) — later tasks reference these by name.

- [ ] **Step 1: Write `infra/cloud_sql.tf`**

```hcl
resource "random_password" "db_password" {
  length  = 24
  special = false
}

resource "google_sql_database_instance" "postgres" {
  project             = var.project_id
  name                = "${var.service_name}-db"
  region              = var.region
  database_version    = "POSTGRES_15"
  deletion_protection = var.deletion_protection

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
    }
  }

  depends_on = [google_project_service.apis]
}

resource "google_sql_database" "app" {
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app" {
  project  = var.project_id
  name     = var.db_user
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
}
```

- [ ] **Step 2: Write `infra/firestore.tf`**

```hcl
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
```

- [ ] **Step 3: Write `infra/secrets.tf`**

```hcl
resource "random_password" "django_secret_key" {
  length  = 50
  special = true
}

resource "google_secret_manager_secret" "django_secret_key" {
  project   = var.project_id
  secret_id = "${var.service_name}-django-secret-key"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "django_secret_key" {
  secret      = google_secret_manager_secret.django_secret_key.id
  secret_data = random_password.django_secret_key.result
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "${var.service_name}-db-password"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret" "gemini_api_key" {
  project   = var.project_id
  secret_id = "${var.service_name}-gemini-api-key"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "gemini_api_key" {
  secret      = google_secret_manager_secret.gemini_api_key.id
  secret_data = var.gemini_api_key
}
```

- [ ] **Step 4: Validate**

Run: `cd infra && terraform validate`
Expected: `Success! The configuration is valid.`

Run: `terraform fmt -check -recursive`
Expected: no output, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add infra/cloud_sql.tf infra/firestore.tf infra/secrets.tf
git commit -m "feat(infra): add Cloud SQL, Firestore, and Secret Manager resources"
```

---

### Task 7: Terraform compute layer — service account, Cloud Run, outputs

**Files:**
- Create: `infra/service_account.tf`
- Create: `infra/cloud_run.tf`
- Create: `infra/outputs.tf`

**Interfaces:**
- Consumes: `google_sql_database_instance.postgres`, `google_secret_manager_secret.*` (Task 6); `google_artifact_registry_repository.backend` (Task 5); `var.container_image`, `var.cpu`, `var.memory`, `var.max_instance_count`, `var.allow_unauthenticated`, `var.django_allowed_hosts`, `var.db_name`, `var.db_user`.
- Produces: `google_service_account.cloud_run`, `google_cloud_run_v2_service.backend` (with `.uri`), outputs `cloud_run_url`, `artifact_registry_repository`, `cloud_sql_connection_name`, `firestore_database`.

- [ ] **Step 1: Write `infra/service_account.tf`**

```hcl
resource "google_service_account" "cloud_run" {
  project      = var.project_id
  account_id   = "${var.service_name}-run-sa"
  display_name = "Cloud Run runtime SA for ${var.service_name}"
}

resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_firestore_user" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "django_secret_key_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.django_secret_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "gemini_api_key_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.gemini_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}
```

- [ ] **Step 2: Write `infra/cloud_run.tf`**

```hcl
resource "google_cloud_run_v2_service" "backend" {
  project  = var.project_id
  name     = var.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloud_run.email

    scaling {
      min_instance_count = 0
      max_instance_count = var.max_instance_count
    }

    containers {
      image = var.container_image

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      env {
        name  = "DJANGO_DEBUG"
        value = "False"
      }

      env {
        name  = "DJANGO_ALLOWED_HOSTS"
        value = var.django_allowed_hosts
      }

      env {
        name  = "DB_ENGINE"
        value = "postgres"
      }

      env {
        name  = "DB_NAME"
        value = var.db_name
      }

      env {
        name  = "DB_USER"
        value = var.db_user
      }

      env {
        name  = "DB_HOST"
        value = "/cloudsql/${google_sql_database_instance.postgres.connection_name}"
      }

      env {
        name  = "DB_PORT"
        value = "5432"
      }

      env {
        name = "DJANGO_SECRET_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.django_secret_key.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GEMINI_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.gemini_api_key.secret_id
            version = "latest"
          }
        }
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.postgres.connection_name]
      }
    }
  }

  depends_on = [
    google_project_service.apis,
    google_secret_manager_secret_version.django_secret_key,
    google_secret_manager_secret_version.db_password,
    google_secret_manager_secret_version.gemini_api_key,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
```

Note: no `lifecycle { ignore_changes = [...] }` block on the image — the two-pass bootstrap flow (documented in Task 8's README) depends on the second `terraform apply` actually updating the image once the real one is pushed.

- [ ] **Step 3: Write `infra/outputs.tf`**

```hcl
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
```

- [ ] **Step 4: Validate the full configuration**

Run: `cd infra && terraform validate`
Expected: `Success! The configuration is valid.`

Run: `terraform fmt -check -recursive`
Expected: no output, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add infra/service_account.tf infra/cloud_run.tf infra/outputs.tf
git commit -m "feat(infra): add Cloud Run service, runtime service account, and outputs"
```

---

### Task 8: tfvars example, gitignore, and README

**Files:**
- Create: `infra/terraform.tfvars.example`
- Create: `infra/.gitignore`
- Create: `infra/README.md`

**Interfaces:** None (documentation/config only — no `.tf` resources).

- [ ] **Step 1: Write `infra/.gitignore`**

```
.terraform/
*.tfstate
*.tfstate.*
crash.log
terraform.tfvars
!terraform.tfvars.example
```

- [ ] **Step 2: Write `infra/terraform.tfvars.example`**

```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"

# Required, no default - the app's google-generativeai integration reads this.
gemini_api_key = "your-gemini-api-key"

# Everything below has a sensible default from variables.tf; override only
# if you need to.
# service_name          = "grocery-backend"
# db_tier               = "db-f1-micro"
# firestore_location    = "nam5"
# allow_unauthenticated = true
# deletion_protection   = false
```

- [ ] **Step 3: Write `infra/README.md`**

```markdown
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

## Tearing down

```bash
terraform destroy
```

Note `deletion_protection` on the Cloud SQL instance must be `false` (the
default) for `destroy` to remove it.
```

- [ ] **Step 4: Verify the gitignore actually excludes real tfvars**

Run:
```bash
cd infra
echo 'project_id = "test"' > terraform.tfvars
git check-ignore -v terraform.tfvars
rm terraform.tfvars
```
Expected: `git check-ignore` prints a match against `infra/.gitignore` (confirms the real file is excluded); after `rm`, `git status` shows no `infra/terraform.tfvars`.

- [ ] **Step 5: Final full-repo check**

Run: `cd infra && terraform fmt -check -recursive && terraform validate`
Expected: both succeed with no formatting diffs and `Success! The configuration is valid.`

- [ ] **Step 6: Commit**

```bash
git add infra/.gitignore infra/terraform.tfvars.example infra/README.md
git commit -m "docs(infra): add README, tfvars example, and gitignore"
```

---

## Post-plan note

This plan does not run `terraform apply` against a real GCP project — `project_id` and `gemini_api_key` have no defaults and must be supplied by the user in a gitignored `terraform.tfvars` (see Task 8's README). All verification in this plan uses `terraform validate`/`fmt`, `docker build`, and the Django test suite, none of which require live GCP credentials.
