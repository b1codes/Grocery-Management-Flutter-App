import os
from pathlib import Path


def get_bool_env(name: str, default: bool) -> bool:
    value = os.environ.get(name)
    if value is None or value == '':
        return default
    return value.strip().lower() in ('true', '1', 'yes')


def get_list_env(name: str, default: list) -> list:
    value = os.environ.get(name)
    if value is None or value == '':
        return default
    return [item.strip() for item in value.split(',') if item.strip()]


def build_database_config(base_dir: Path) -> dict:
    engine = os.environ.get('DB_ENGINE', 'sqlite')

    if engine == 'sqlite':
        return {
            'default': {
                'ENGINE': 'django.db.backends.sqlite3',
                'NAME': base_dir / 'db.sqlite3',
            }
        }

    if engine == 'postgres':
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

    raise ValueError(f"Unsupported DB_ENGINE={engine!r}; expected 'sqlite' or 'postgres'")
