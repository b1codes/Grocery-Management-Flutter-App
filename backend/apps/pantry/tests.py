from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from django.contrib.auth import get_user_model
from apps.pantry.models import PantryItem, Category

User = get_user_model()

class PantryThresholdTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(email='test@example.com', username='testuser', password='password')
        self.client.force_authenticate(user=self.user)
        self.category = Category.objects.create(name='Test Category')

    def test_create_pantry_item_with_threshold_and_unit(self):
        data = {
            'name': 'Milk',
            'quantity': 2.5,
            'unit': 'l',
            'min_threshold': 0.5,
            'category': self.category.id,
            'regular_price': 3.50
        }
        response = self.client.post('/api/pantry/pantry-items/', data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(float(response.data['quantity']), 2.5)
        self.assertEqual(response.data['unit'], 'l')
        self.assertEqual(float(response.data['min_threshold']), 0.5)
        
        item = PantryItem.objects.get(id=response.data['id'])
        self.assertEqual(float(item.quantity), 2.5)
        self.assertEqual(item.unit, 'l')

    def test_update_pantry_item_threshold_and_unit(self):
        item = PantryItem.objects.create(
            user=self.user,
            name='Bread',
            quantity=5.0,
            unit='count',
            min_threshold=1.0,
            regular_price=2.50
        )
        data = {'min_threshold': 2.5, 'unit': 'oz'}
        response = self.client.patch(f'/api/pantry/pantry-items/{item.id}/', data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(float(response.data['min_threshold']), 2.5)
        self.assertEqual(response.data['unit'], 'oz')
        
        item.refresh_from_db()
        self.assertEqual(float(item.min_threshold), 2.5)
        self.assertEqual(item.unit, 'oz')
