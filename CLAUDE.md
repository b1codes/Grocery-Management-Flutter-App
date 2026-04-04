# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A full-stack grocery management app with a Flutter frontend and Django REST Framework backend.

## Commands

### Frontend (Flutter) — run from `frontend/`

```bash
flutter pub get                     # Install dependencies
dart run build_runner build         # Regenerate dart_mappable *.mapper.dart files
flutter run                         # Run the app (defaults to dev environment)
flutter analyze                     # Lint
flutter test                        # Run all tests
flutter test test/bloc/pantry_bloc_test.dart  # Run a single test file
```

To run with a specific environment:
```bash
flutter run --dart-define=ENV=dev
```

### Backend (Django) — run from `backend/`

```bash
pipenv install          # Install dependencies
pipenv shell            # Activate virtualenv
python manage.py migrate
python manage.py runserver          # Starts at http://127.0.0.1:8000
```

## Architecture

### Frontend (`frontend/lib/`)

The app uses a strict layered BLoC architecture:

```
UI Screens → BLoCs → Managers → API classes → ApiClient (Dio)
```

- **`bloc/`** — One BLoC per feature (`auth`, `pantry`, `trips`, `budget`, `store`, `portal`). Each BLoC receives injected manager(s) via constructor. Events live in `bloc/<feature>/events/`.
- **`services/managers/`** — Repository layer. All managers are registered as `RepositoryProvider` in `main.dart` and injected into BLoCs there. Managers hold no state; they call API classes and return models.
- **`networking/api/`** — Thin API wrappers around `ApiClient` (Dio singleton). Each class maps to a backend resource.
- **`networking/dto/`** — JSON DTOs annotated with `@MappableClass(caseStyle: CaseStyle.snakeCase)` from `dart_mappable`. **Any time a DTO is added or changed, run `dart run build_runner build`** to regenerate the corresponding `*.mapper.dart` file.
- **`models/`** — Plain Dart model classes (no annotations). DTOs are converted to/from models in managers.
- **`screens/`** — Feature-organized UI screens. Screens are `StatelessWidget`s that use `BlocBuilder`/`BlocListener`.

**App startup sequence** (`main.dart`):
1. `StartupServices.startServices()` — registers all dart_mappable mappers
2. `AppConfig.load(environment)` — loads `envs/{env}.json` (base URL, etc.)
3. `ApiClient().init(baseUrl)` — initializes the Dio singleton
4. `MultiRepositoryProvider` wraps the widget tree with all managers
5. `MultiBlocProvider` provides `AuthBloc` and `PortalBloc` globally
6. `AuthWrapper` routes to `LoginScreen` or `PortalScreen` based on auth state

**Auth token flow**: `AuthManager.login()` calls `ApiClient.setAuthToken()`, which attaches `Authorization: Token <token>` to all subsequent Dio requests.

### Backend (`backend/`)

Django project with modular apps under `apps/`:

- **`apps/generic/`** — `DefaultModel` base class (all models inherit this): adds `status` (active/inactive), `created_at`, `updated_at`.
- **`apps/authentication/`** — Custom `User` model extending `AbstractBaseUser`.
- **`apps/pantry/`** — `PantryItem`, `Category` models.
- **`apps/grocery/`** — `GroceryTrip`, `Store`, `PurchasedItem` models.
- **`apps/budget/`** — `MonthlyBudget` model.

Each app follows the DRF pattern: `models.py` → `serializers.py` → `views.py` (ModelViewSet) → `urls.py` (DefaultRouter).

**Note:** App-level URLs are defined but must be included via `path('api/', include(...))` in `config/urls.py` to be active.

## Testing

Tests are in `frontend/test/`. BLoC tests use `bloc_test` + `mocktail`. The pattern is:
1. Create a `Mock<ManagerClass>` with mocktail
2. Use `blocTest<XBloc, XState>(...)` to dispatch events and verify emitted states
3. Inject the mock manager into the BLoC constructor

## Environment Config

Frontend environment is loaded from `frontend/envs/{env}.json`. The default is `dev` (points to `http://localhost:8000`). Pass `--dart-define=ENV=<name>` to `flutter run`/`flutter build` to switch environments.
