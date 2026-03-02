# Django Feature Scaffolding Skill

Expert guidance for adding new backend features and API modules in the Django project.

## 📋 Instructions

Follow these steps when adding a new module to `backend/apps/`:

1.  **Module Creation**: Create the directory `backend/apps/<module_name>/`.
2.  **Models**: Define your models in `models.py`. Always use `get_user_model()` for user references.
3.  **Serializers**: Create `serializers.py` using Django REST Framework's `ModelSerializer`.
4.  **Views**: Create `views.py` using DRF generic views or ViewSets.
5.  **URLs**: 
    - Create `backend/apps/<module_name>/urls.py`.
    - Register the module's URLs in the main `backend/config/urls.py`.
6.  **Migrations**: Generate and apply migrations:
    ```bash
    cd backend && python manage.py makemigrations <module_name> && python manage.py migrate
    ```

## 🛠️ Resources

-   **Serializers**: Use `ModelSerializer` for consistency.
-   **Views**: Prefer `ListCreateAPIView` and `RetrieveUpdateDestroyAPIView` for standard CRUD.
