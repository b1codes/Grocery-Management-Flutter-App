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

    def test_create_pantry_item_with_threshold(self):
        data = {
            'name': 'Milk',
            'quantity': 2,
            'min_threshold': 3,
            'category': self.category.id,
            'regular_price': 3.50
        }
        response = self.client.post('/api/pantry/pantry-items/', data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['min_threshold'], 3)
        
        item = PantryItem.objects.get(id=response.data['id'])
        self.assertEqual(item.min_threshold, 3)

    def test_update_pantry_item_threshold(self):
        item = PantryItem.objects.create(
            user=self.user,
            name='Bread',
            quantity=5,
            min_threshold=1,
            regular_price=2.50
        )
        data = {'min_threshold': 2}
        response = self.client.patch(f'/api/pantry/pantry-items/{item.id}/', data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['min_threshold'], 2)
        
        item.refresh_from_db()
        self.assertEqual(item.min_threshold, 2)
