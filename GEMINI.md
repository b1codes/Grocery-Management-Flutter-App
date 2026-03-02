# GEMINI.md - Grocery Management App

## Project Overview

A full-stack grocery management mobile application built with **Flutter** (Frontend) and **Django REST Framework** (Backend). The app allows users to manage their pantry, plan shopping trips, track budgets, and store favorite grocery store locations.

### Key Technologies
- **Frontend**: Flutter (SDK ^3.9.2), `flutter_bloc`, `dio`, `dart_mappable`.
- **Backend**: Python 3.12, Django, Django REST Framework, Pipenv, SQLite.

## Project Structure

```text
/
├── backend/            # Django REST API
│   ├── apps/           # Application modules (authentication, pantry, grocery, etc.)
│   ├── config/         # Django project settings and root URLs
│   ├── Pipfile         # Python dependencies
│   └── manage.py       # Django management script
└── frontend/           # Flutter Mobile App
    ├── lib/            # Dart source code
    │   ├── bloc/       # State management using BLoC
    │   ├── screens/    # UI screens
    │   ├── services/   # Business logic and API managers
    │   ├── models/     # Data models (using dart_mappable)
    │   └── networking/ # API client configuration
    ├── envs/           # Environment configuration files
    └── pubspec.yaml    # Flutter dependencies
```

## Building and Running

### Backend (Django)
1. **Setup**:
   ```bash
   cd backend
   pipenv install
   pipenv shell
   ```
2. **Database**:
   ```bash
   python manage.py migrate
   ```
3. **Run**:
   ```bash
   python manage.py runserver
   ```
4. **Test**:
   ```bash
   python manage.py test
   ```

### Frontend (Flutter)
1. **Setup**:
   ```bash
   cd frontend
   flutter pub get
   ```
2. **Code Generation** (Mandatory for models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. **Run**:
   ```bash
   flutter run --dart-define=ENV=dev
   ```
4. **Test**:
   ```bash
   flutter test
   ```

## Development Conventions

### Backend
- **Custom User Model**: The project uses a custom user model located at `apps.authentication.models.User`. Always use `get_user_model()` to reference it.
- **API Responses**: Use Django REST Framework serializers and views.
- **Testing**: Follow standard Django `TestCase` patterns in `tests.py` within each app module.

### Frontend
- **State Management**: Use `flutter_bloc`. BLoCs are located in `lib/bloc/`.
- **JSON Serialization**: Use `dart_mappable`. Run `build_runner` after changing models in `lib/models/`.
- **Networking**: Use the `ApiClient` (based on `dio`) initialized in `main.dart`.
- **Configuration**: App configuration is loaded from `envs/*.json` based on the `ENV` dart-define.
- **Linting**: Follow rules defined in `analysis_options.yaml` (includes `package:flutter_lints/flutter.yaml`).

## Common Tasks

- **Adding a new model (Frontend)**: Define the class in `lib/models/`, annotate with `@MappableClass()`, and run `dart run build_runner build`.
- **Adding a new API endpoint (Backend)**: Create a model (if needed), a serializer in `apps/<module>/serializers.py`, a view in `apps/<module>/views.py`, and register the URL in `apps/<module>/urls.py`.
- **Environment Switching**: Add a new `.json` file in `frontend/envs/` and run the app with `--dart-define=ENV=<name>`.
