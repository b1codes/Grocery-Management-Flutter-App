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
